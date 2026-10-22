"""Offline safeguards: no GitHub writes, Supabase calls or deployment."""
import json
import tempfile
import unittest
from pathlib import Path

from audit_candidate import REQUIRED, validate as validate_candidate
from guard import validate as validate_intent
from public_tmb_env import extract, write_github_env


REVISION = "a" * 12
SHA = "a" * 40


class ReleaseGuardTests(unittest.TestCase):
    def test_explicit_intent_only(self):
        self.assertTrue(validate_intent("workflow_dispatch", "refs/heads/main", SHA))
        self.assertTrue(validate_intent("workflow_dispatch", "refs/heads/main", SHA,
                                        "publish", "PUBLICAR", SHA))

    def test_publish_requires_confirmation(self):
        for word in ("", "publish", "Publicar", "PUBLICAR "):
            with self.assertRaises(ValueError):
                validate_intent("workflow_dispatch", "refs/heads/main", SHA,
                                "publish", word)

    def test_wrong_branch_event_or_commit_rejected(self):
        for event, ref, sha, expected in (
            ("push", "refs/heads/main", SHA, ""),
            ("pull_request", "refs/heads/main", SHA, ""),
            ("workflow_dispatch", "refs/heads/pages-production", SHA, ""),
            ("workflow_dispatch", "refs/heads/main", "not-a-sha", ""),
            ("workflow_dispatch", "refs/heads/main", SHA, "b" * 40),
        ):
            with self.assertRaises(ValueError):
                validate_intent(event, ref, sha, expected_sha=expected)


class CandidateTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.web = Path(self.temp.name)
        for name in REQUIRED:
            path = self.web / name
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(b"test")
        for i in range(60):
            (self.web / "assets/assets/resolucion" / f"fixture{i}.jpg").write_bytes(b"x")
        (self.web / "version.json").write_text(json.dumps({"revision": REVISION}))
        (self.web / "index.html").write_text('<base href="/incidencias-l4/">access-entry.js')
        (self.web / "access-entry.js").write_text(
            f"createGate import('/tmb-agent/src/session.js'); flutter_bootstrap.js?v={REVISION}")
        (self.web / "flutter_bootstrap.js").write_text(f"main.dart.js?v={REVISION}")
        (self.web / "main.dart.js").write_text("sb_publishable_" + "z" * 100_000)

    def test_good_candidate(self):
        self.assertEqual(validate_candidate(self.web, REVISION, True)["mode"], "operational")

    def test_missing_access_gate_rejected(self):
        (self.web / "access-entry.js").unlink()
        with self.assertRaisesRegex(ValueError, "Missing web release file"):
            validate_candidate(self.web, REVISION)

    def test_placeholder_rejected(self):
        (self.web / "main.dart.js").write_text("sb_publishable_" + "x" * 100_000 +
                                                "build-only-placeholder")
        with self.assertRaisesRegex(ValueError, "Non-operational"):
            validate_candidate(self.web, REVISION, True)

    def test_revision_mismatch_rejected(self):
        with self.assertRaisesRegex(ValueError, "revision mismatch"):
            validate_candidate(self.web, "b" * 12)

    def test_missing_ddus_rejected(self):
        (self.web / "assets/assets/resolucion/pictogramas_s9000_ddu.png").unlink()
        with self.assertRaisesRegex(ValueError, "Missing web release file"):
            validate_candidate(self.web, REVISION)


class TMBPublicConfigurationTests(unittest.TestCase):
    def setUp(self):
        self.project = "a" * 20
        self.url = f"https://{self.project}.supabase.co"
        self.key = "sb_publishable_" + "x" * 24
        self.source = (
            f"export const SESSION_KEY = 'sb-{self.project}-auth-token';\n"
            f"const URL = '{self.url}';\n"
            f"const PUBLIC_KEY = '{self.key}';\n"
        )

    def test_public_config_is_derived_from_pinned_module(self):
        with tempfile.TemporaryDirectory() as tmp:
            env_path = Path(tmp) / "env"
            env_path.touch()
            write_github_env(env_path, extract(self.source))
            lines = env_path.read_text().splitlines()
            self.assertIn(f"L4_SUPABASE_URL={self.url}", lines)
            self.assertIn(f"L4_SUPABASE_PUBLISHABLE_KEY={self.key}", lines)
            self.assertNotIn("L4_ADMIN_EMAIL", env_path.read_text())

    def test_contract_change_is_rejected(self):
        for source in ("", self.source.replace("auth-token", "wrong"),
                       self.source.replace("sb_publishable_", "sb_secret_")):
            with self.assertRaises(ValueError):
                extract(source)
