#!/usr/bin/env python3
"""Test runner for the Seed exercises.

Usage:
    ./run-tests.py --impl "CMD" [SELECTOR ...]
    ./run-tests.py --impl "CMD" --upto SELECTOR
    ./run-tests.py --impl "CMD" --progress

CMD is the command that runs your interpreter, e.g. "./seed" or
"python3 my_seed.py". It may also be given via the SEED_IMPL environment
variable.

A SELECTOR is a section number ("2"), a stage ("2.3"), or a directory name
("02-evaluating-data"). With no selector, every available stage is run.
--upto runs every stage up to and including the one selected, so earlier
stages keep passing as you go. When every stage is run, the runner also
reports which sections of the spec your interpreter has unlocked.

See exercises/README.md for the test format and the harness modes.
"""
import argparse
import difflib
import json
import os
import shlex
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
EXERCISES = ROOT / "exercises"
MODE_FLAGS = {"run": [], "read": ["--read"], "print": ["--print"]}

USE_COLOR = sys.stdout.isatty() and os.environ.get("NO_COLOR") is None


def color(text, code):
    return f"\033[{code}m{text}\033[0m" if USE_COLOR else text


def green(t): return color(t, "32")
def red(t): return color(t, "31")
def dim(t): return color(t, "2")
def bold(t): return color(t, "1")


def numbered_dirs(path):
    return sorted(p for p in path.iterdir() if p.is_dir() and p.name[:2].isdigit())


class Stage:
    def __init__(self, section, path):
        self.section = section
        self.path = path
        self.key = (int(section.name[:2]), int(path.name[:2]))
        self.id = "%d.%d" % self.key
        self.config = json.loads((path / "stage.json").read_text(encoding="utf-8"))
        self.title = self.config.get("title", path.name)


def all_stages():
    return [Stage(sec, st) for sec in numbered_dirs(EXERCISES) for st in numbered_dirs(sec)]


def parse_selector(sel, stages):
    if sel.replace(".", "").isdigit():
        parts = tuple(int(p) for p in sel.split("."))
        if len(parts) == 1:
            found = [s for s in stages if s.key[0] == parts[0]]
        else:
            found = [s for s in stages if s.key == parts[:2]]
    else:
        found = [s for s in stages if sel in (s.section.name, s.path.name,
                                               f"{s.section.name}/{s.path.name}")]
    if not found:
        sys.exit(f"run-tests: no stage matches {sel!r}")
    return found


def select(selectors, upto, stages):
    if upto:
        if selectors:
            sys.exit("run-tests: give either selectors or --upto, not both")
        last = max(s.key for s in parse_selector(upto, stages))
        return [s for s in stages if s.key <= last]
    if not selectors:
        return stages
    chosen = []
    for sel in selectors:
        chosen.extend(s for s in parse_selector(sel, stages) if s not in chosen)
    return sorted(chosen, key=lambda s: s.key)


class Result:
    def __init__(self, name, ok, reason="", detail=""):
        self.name, self.ok, self.reason, self.detail = name, ok, reason, detail


def indent(text, n=6):
    pad = " " * n
    return "\n".join(pad + line for line in text.rstrip("\n").splitlines())


def run_test(impl, stage, name, opts, default_timeout):
    test = stage.path / f"{name}.scm"
    mode = opts.get("mode", stage.config.get("mode", "run"))
    files = [str((stage.path / f).resolve()) for f in opts.get("load", [])] + [str(test)]
    stdin_path = test.with_suffix(".in")
    stdin_data = stdin_path.read_bytes() if stdin_path.exists() else b""
    out_path = test.with_suffix(".out")
    expected = out_path.read_text(encoding="utf-8") if out_path.exists() else ""
    timeout = opts.get("timeout", default_timeout)

    try:
        proc = subprocess.run(impl + MODE_FLAGS[mode] + files, input=stdin_data,
                              capture_output=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return Result(name, False, f"timed out after {timeout:g}s")
    except OSError as e:
        return Result(name, False, f"could not run implementation: {e}")

    stdout = proc.stdout.decode("utf-8", errors="replace")
    stderr = proc.stderr.decode("utf-8", errors="replace")
    stderr_tail = "\n".join(stderr.strip().splitlines()[-5:])

    if opts.get("expect") == "error":
        if proc.returncode == 0:
            return Result(name, False, "expected an error (non-zero exit), but exit status was 0",
                          ("stdout:\n" + indent(stdout)) if stdout else "")
        if not stderr.strip():
            return Result(name, False, "expected a diagnostic on stderr, but stderr was empty")
    elif proc.returncode != 0:
        return Result(name, False, f"exit status {proc.returncode}, expected 0",
                      ("stderr:\n" + indent(stderr_tail)) if stderr_tail else "")

    if opts.get("stdout", "exact") == "exact" and stdout != expected:
        diff = "".join(difflib.unified_diff(expected.splitlines(keepends=True),
                                            stdout.splitlines(keepends=True),
                                            "expected", "actual"))
        if stderr_tail:
            diff += "\nstderr:\n" + indent(stderr_tail)
        return Result(name, False, "stdout differs", diff)
    return Result(name, True)


def report_spec(manifest, status, available_sections):
    """A spec section is unlocked when the exercise section that completes it is
    available and every stage that tests it passes."""
    contributors = {}
    for sec in manifest["sections"]:
        for st in sec["stages"]:
            for spec in st["spec"]:
                contributors.setdefault(spec, []).append(st["id"])
    unlocked = 0
    lines = []
    for spec, title in manifest["spec"].items():
        done_in = manifest["completed_by"][spec]
        stages = contributors.get(spec, [])
        if done_in in available_sections and all(status.get(s) for s in stages):
            unlocked += 1
            lines.append(f"  {green('[x]')} {spec:<5} {title}")
        else:
            missing = [s for s in stages if not status.get(s)]
            why = []
            if missing:
                why.append("needs stage " + ", ".join(missing))
            if done_in not in available_sections:
                word = "rest arrives" if stages else "arrives"
                why.append(f"{word} with section {done_in}")
            lines.append(f"  [ ] {spec:<5} {title}  {dim('(' + '; '.join(why) + ')')}")
    print(f"Spec sections unlocked: {unlocked}/{len(manifest['spec'])}")
    print("\n".join(lines))


def main():
    ap = argparse.ArgumentParser(description="Run the Seed exercise tests.")
    ap.add_argument("selectors", nargs="*", help="sections or stages, e.g. 2 or 2.3 (default: all)")
    ap.add_argument("--impl", default=os.environ.get("SEED_IMPL"),
                    help="command that runs your interpreter (or set SEED_IMPL)")
    ap.add_argument("--upto", metavar="STAGE", help="run every stage up to and including STAGE")
    ap.add_argument("--progress", action="store_true",
                    help="print one line per stage instead of per-test detail")
    ap.add_argument("--timeout", type=float, default=30.0,
                    help="default per-test timeout in seconds (default: 30)")
    ap.add_argument("-x", "--stop", action="store_true",
                    help="stop at the first stage that does not fully pass")
    args = ap.parse_args()
    if not args.impl:
        ap.error("no implementation given: pass --impl CMD or set SEED_IMPL")
    impl = shlex.split(args.impl)

    stages = all_stages()
    chosen = select(args.selectors, args.upto, stages)
    manifest_path = EXERCISES / "manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else None
    titles = {s["dir"]: s["title"] for s in manifest["sections"]} if manifest else {}

    total_pass = total = 0
    status = {}
    current = None
    for st in chosen:
        if st.section != current:
            current = st.section
            title = titles.get(current.name, current.name[3:].replace("-", " ").capitalize())
            print(bold(f"Section {int(current.name[:2])}: {title}"))
        tests = st.config["tests"]
        results = [run_test(impl, st, name, opts, args.timeout) for name, opts in tests.items()]
        passed = sum(r.ok for r in results)
        total_pass += passed
        total += len(results)
        done = passed == len(results)
        status[st.id] = done
        mark = green("[x]") if done else "[ ]"
        print(f"  {mark} {st.id:<5} {st.title:<36} {passed:>2}/{len(results)} tests passed")
        if not args.progress:
            for r in results:
                if not r.ok:
                    print(f"        {red('FAIL')} {r.name}: {r.reason}")
                    if r.detail:
                        print(dim(indent(r.detail, 10)))
        if args.stop and not done:
            break

    print()
    print(f"{total_pass}/{total} tests passed; {sum(status.values())} stage(s) complete.")
    if manifest and len(status) == len(stages):
        print()
        report_spec(manifest, status, {int(p.name[:2]) for p in numbered_dirs(EXERCISES)})
    sys.exit(0 if total_pass == total else 1)


if __name__ == "__main__":
    main()
