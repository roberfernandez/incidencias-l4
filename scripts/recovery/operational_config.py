"""Validate public build configuration offline. Does not deploy or contact Supabase."""
import json, os, pathlib, re, subprocess, tempfile, argparse

def validate(env, session_source):
    url = env.get("L4_SUPABASE_URL", "")
    key = env.get("L4_SUPABASE_PUBLISHABLE_KEY", "")
    if env.get("L4_ADMIN_EMAIL", ""):
        raise ValueError("Personal email must not be embedded in public JavaScript")
    if not re.fullmatch(r"https://[a-z0-9]{20}\.supabase\.co", url):
        raise ValueError("A real HTTPS project URL is required")
    if not re.fullmatch(r"sb_publishable_[A-Za-z0-9_-]{20,}", key):
        raise ValueError("Only a public publishable key is accepted")
    expected_url = re.search(r"const URL = '([^']+)'", session_source)
    expected_key = re.search(r"const PUBLIC_KEY = '([^']+)'", session_source)
    expected_storage = re.search(r"export const SESSION_KEY = '([^']+)'", session_source)
    project = url.split("//")[1].split(".")[0]
    if not expected_url or not expected_key or not expected_storage:
        raise ValueError("Unrecognized TMB session contract; review before building")
    if (url != expected_url[1] or key != expected_key[1] or
            expected_storage[1] != f"sb-{project}-auth-token"):
        raise ValueError("Configuration does not match the reviewed TMB session module")
    return {"L4_SUPABASE_URL": url, "L4_SUPABASE_PUBLISHABLE_KEY": key,
            "L4_ADMIN_EMAIL": ""}

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--session-module", type=pathlib.Path, required=True)
    parser.add_argument("--build", action="store_true", help="Compile only; never deploy")
    args = parser.parse_args()
    try:
        config = validate(os.environ, args.session_module.read_text(encoding="utf-8"))
    except (ValueError, OSError):
        parser.exit(2, "Configuration rejected. Check public values, TMB contract and privacy policy.\n")
    if not args.build:
        print("Public configuration matches TMB Agent; no build or deployment performed.")
        return
    root = pathlib.Path(__file__).resolve().parents[2]
    # Temporary JSON outside the checkout; values never printed in logs.
    with tempfile.TemporaryDirectory(prefix="l4-build-") as temp:
        defines = pathlib.Path(temp) / "defines.json"
        defines.write_text(json.dumps(config), encoding="utf-8")
        subprocess.run(["flutter", "pub", "get", "--enforce-lockfile"], cwd=root / "app", check=True)
        subprocess.run(["flutter", "build", "web", "--release",
            "--base-href", "/incidencias-l4/", "--pwa-strategy=none",
            "--no-web-resources-cdn", f"--dart-define-from-file={defines}"],
            cwd=root / "app", check=True)
    subprocess.run(["python3", str(root / "scripts/recovery/package_web.py")], check=True)
    print("Operational build candidate only. Manual validation and publication authorization still required.")

if __name__ == "__main__":
    main()
