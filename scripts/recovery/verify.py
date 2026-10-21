"""Offline recovery validation; does not query or modify Supabase."""
import hashlib, json, pathlib, re, subprocess
root = pathlib.Path(__file__).resolve().parents[2]
manifest = json.loads((root / "docs/recovery/inventory.json").read_text(encoding="utf-8"))
for item in manifest["files"]:
    p = root / "app" / item["path"]
    assert p.is_file(), f"Missing source/resource: {item['path']}"
    digest = hashlib.sha256(p.read_bytes()).hexdigest()
    if digest != item["sha256"]:
        # Keep the originally recovered SHA-256 in the provenance manifest.
        # Only this reviewed, narrowly scoped test amendment is permitted.
        approved_git_blobs = {
            "test/manual_inventory_test.dart": "773ad38aa79958034bc7b9d39c34c9f19a7aabfc",
            "test/s9000_ui_test.dart": "1ff62323d117aaa49466941a2e30886e8c698c5a",
        }
        actual_blob = subprocess.check_output(
            ["git", "hash-object", str(p)], cwd=root, text=True
        ).strip()
        assert approved_git_blobs.get(item["path"]) == actual_blob, (
            f"Unapproved inventory drift: {item['path']}"
        )
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
