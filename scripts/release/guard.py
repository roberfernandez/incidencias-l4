"""Fail-closed checks for manually requested Incidències L4 publication.

No GitHub, Pages or Supabase writes. All user inputs come from environment.
"""
import os
import re
import sys


def validate(event, ref, sha, action="check", confirmation="", expected_sha=""):
    if event != "workflow_dispatch":
        raise ValueError("Manual operation requires workflow_dispatch")
    if ref != "refs/heads/main":
        raise ValueError("Only main may be built for an operational release")
    if action not in ("check", "publish"):
        raise ValueError("Unrecognized operation")
    if not re.fullmatch(r"[0-9a-f]{40}", sha):
        raise ValueError("Invalid source commit")
    if expected_sha and expected_sha.lower() != sha:
        raise ValueError("Requested commit does not match this run")
    if action == "publish" and confirmation != "PUBLICAR":
        raise ValueError("Publishing requires the exact confirmation PUBLICAR")
    return True


def main():
    try:
        validate(
            os.environ.get("GITHUB_EVENT_NAME", ""),
            os.environ.get("GITHUB_REF", ""),
            os.environ.get("GITHUB_SHA", ""),
            os.environ.get("L4_OPERATION", "check"),
            os.environ.get("L4_CONFIRMATION", ""),
            os.environ.get("L4_EXPECTED_SHA", ""),
        )
    except ValueError as error:
        sys.exit(f"Rejected release operation: {error}\n")
    print("Manual operation and source revision verified; nothing deployed.")


if __name__ == "__main__":
    main()
