"""Derive public Supabase configuration from a PINNED TMB Agent module.

These are browser-public client values, not a service-role key. The user's
personal email exception is deliberately never extracted here.
"""
import argparse
import re
from pathlib import Path


def extract(source: str) -> dict[str, str]:
    values = {}
    patterns = {
        "L4_SUPABASE_URL": r"const URL = '(https://[a-z0-9]{20}\.supabase\.co)'",
        "L4_SUPABASE_PUBLISHABLE_KEY": r"const PUBLIC_KEY = '(sb_publishable_[A-Za-z0-9_-]{20,})'",
        "SESSION_KEY": r"export const SESSION_KEY = '(sb-[a-z0-9]{20}-auth-token)'",
    }
    for key, pattern in patterns.items():
        match = re.search(pattern, source)
        if not match:
            raise ValueError("Unrecognized pinned TMB public session contract")
        values[key] = match.group(1)
    project = values["L4_SUPABASE_URL"].split("//", 1)[1].split(".", 1)[0]
    if values["SESSION_KEY"] != f"sb-{project}-auth-token":
        raise ValueError("Mismatch between TMB project and session key")
    return values


def write_github_env(destination: Path, values: dict[str, str]) -> None:
    if not destination.is_file():
        raise ValueError("GITHUB_ENV file missing; do not print configuration")
    with destination.open("a", encoding="utf-8") as file:
        for name in ("L4_SUPABASE_URL", "L4_SUPABASE_PUBLISHABLE_KEY"):
            file.write(f"{name}={values[name]}\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--session-module", type=Path, required=True)
    parser.add_argument("--github-env", type=Path, required=True)
    args = parser.parse_args()
    try:
        values = extract(args.session_module.read_text(encoding="utf-8"))
        write_github_env(args.github_env, values)
    except (ValueError, OSError) as error:
        parser.exit(2, f"Could not load TMB public configuration: {error}\n")
    print("Pinned TMB public configuration loaded (no values logged).")


if __name__ == "__main__":
    main()
