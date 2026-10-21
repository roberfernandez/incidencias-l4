"""Offline recovery validation; does not query or modify Supabase."""
import hashlib, json, pathlib, re, subprocess
root = pathlib.Path(__file__).resolve().parents[2]
manifest = json.loads((root / "docs/recovery/inventory.json").read_text(encoding="utf-8"))
for item in manifest["files"]:
    p = root / "app" / item["path"]
    assert p.is_file(), f"Missing source/resource: {item['path']}"
    assert hashlib.sha256(p.read_bytes()).hexdigest() == item["sha256"], f"Inventory drift: {item['path']}"
for p in (root / "app").rglob("*"):
    if not p.is_file() or p.suffix.lower() not in {".dart", ".js", ".mjs", ".json", ".yaml", ".html"}:
        continue
    text = p.read_text(encoding="utf-8-sig")
    assert not re.search(r"sb_secret_|ghp_[a-zA-Z0-9]{20,}|-----BEGIN [A-Z ]*PRIVATE KEY", text), f"Possible secret: {p.name}"
    assert not re.search(r"[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+[.][a-zA-Z]{2,}", text), f"Embedded email: {p.name}"
baseline = manifest["baseline_commit"]
changes = subprocess.check_output(["git", "diff", "--name-status", baseline, "HEAD"], cwd=root, text=True)
assert all(line.split()[0] == "A" for line in changes.splitlines()), "Recovery must only add files; published tree changed"
print(f"Verified {len(manifest['files'])} recovered files; published tree unchanged.")
