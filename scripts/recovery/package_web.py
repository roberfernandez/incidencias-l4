"""Package a build-only artifact. Never deploy or contact the backend."""
import json, os, pathlib, shutil
root = pathlib.Path(__file__).resolve().parents[2]
app = root / "app"
out = app / "build/web"
assert (out / "main.dart.js").is_file(), "Compile Flutter first"
# --pwa-strategy=none may omit the retirement worker. Keep the original custom worker.
shutil.copyfile(app / "web/flutter_service_worker.js", out / "flutter_service_worker.js")
revision = os.environ.get("GITHUB_SHA", "local-recovery")[:12]
for name in ("index.html", "access-entry.js", "flutter_bootstrap.js"):
    p = out / name
    text = p.read_text(encoding="utf-8")
    p.write_text(text.replace("s9000-ma-carousel-20261019", revision), encoding="utf-8")
(out / ".nojekyll").write_text("", encoding="utf-8")
(out / "version.json").write_text(json.dumps({
    "app_name": "l4_incidencias", "version": "1.0.0", "build_number": "1",
    "package_name": "l4_incidencias", "revision": revision,
    "purpose": "build-only; no deployment authorized"
}, indent=2), encoding="utf-8")
for name in ("index.html", "access-entry.js", "access-gate.mjs", "flutter_bootstrap.js",
             "flutter_service_worker.js", "manifest.json", "tmb-return.css"):
    assert (out / name).is_file(), f"Missing web integration file: {name}"
assert "access-entry.js" in (out / "index.html").read_text(encoding="utf-8")
print("Web artifact prepared. No deployment performed.")
