"""Audit an assembled Flutter web tree before archiving or deployment.

No network calls or printing of build-time configuration.
"""
import argparse
import json
from pathlib import Path


REQUIRED = (
    ".nojekyll",
    "index.html",
    "access-entry.js",
    "access-gate.mjs",
    "flutter_bootstrap.js",
    "flutter_service_worker.js",
    "main.dart.js",
    "manifest.json",
    "version.json",
    "tmb-return.css",
    "icons/Tren-192.png",
    "assets/AssetManifest.bin.json",
    "assets/assets/resolucion/pictogramas_s9000_localitzacio.png",
    "assets/assets/resolucion/pictogramas_s9000_ddu.png",
)


def validate(directory: Path, revision: str, operational: bool = False) -> dict:
    if not revision or len(revision) < 7:
        raise ValueError("Missing build revision")
    for name in REQUIRED:
        if not (directory / name).is_file():
            raise ValueError(f"Missing web release file: {name}")

    version = json.loads((directory / "version.json").read_text(encoding="utf-8"))
    if version.get("revision") != revision:
        raise ValueError("Build revision mismatch")
    index = (directory / "index.html").read_text(encoding="utf-8")
    gate = (directory / "access-entry.js").read_text(encoding="utf-8")
    bootstrap = (directory / "flutter_bootstrap.js").read_text(encoding="utf-8")
    js_path = directory / "main.dart.js"

    if '<base href="/incidencias-l4/">' not in index or "access-entry.js" not in index:
        raise ValueError("Base path / access gate missing")
    if "/tmb-agent/src/session.js" not in gate or "createGate" not in gate:
        raise ValueError("TMB Agent session gate missing")
    if f"flutter_bootstrap.js?v={revision}" not in gate:
        raise ValueError("Stale bootstrap cache key")
    if f"?v={revision}" not in bootstrap or "main.dart.js" not in bootstrap:
        raise ValueError("Stale Flutter JS cache key")
    if js_path.stat().st_size <= 100_000:
        raise ValueError("Unexpectedly small application bundle")

    # Both the replaced train-location graphic and unchanged DDU image must exist.
    assets = directory / "assets/assets/resolucion"
    if len(list(assets.glob("*.jpg"))) + len(list(assets.glob("*.png"))) < 60:
        raise ValueError("Expected S9000 reference images are missing")

    if operational:
        bundle = js_path.read_text(encoding="utf-8")
        if "build-only-placeholder" in bundle or "https://example.supabase.co" in bundle:
            raise ValueError("Non-operational Flutter build may not be released")
        if "sb_publishable_" not in bundle:
            raise ValueError("Publishable project key is missing from the build")
    return {"revision": revision, "mode": "operational" if operational else "ci"}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--web", type=Path, required=True)
    parser.add_argument("--revision", required=True)
    parser.add_argument("--operational", action="store_true")
    args = parser.parse_args()
    try:
        result = validate(args.web, args.revision, args.operational)
    except (OSError, ValueError, json.JSONDecodeError) as error:
        parser.exit(2, f"Candidate audit failed: {error}\n")
    print(f"Flutter candidate audit passed ({result['mode']}, {result['revision']}).")


if __name__ == "__main__":
    main()
