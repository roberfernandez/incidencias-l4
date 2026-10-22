import unittest
from operational_config import validate

class ConfigurationTests(unittest.TestCase):
    def setUp(self):
        self.url = "https://" + "a" * 20 + ".supabase.co"
        self.key = "sb_publishable_" + "x" * 24
        self.env = {"L4_SUPABASE_URL": self.url, "L4_SUPABASE_PUBLISHABLE_KEY": self.key, "L4_ADMIN_EMAIL": "synthetic-exception"}
        self.source = f"const URL = '{self.url}';\nconst PUBLIC_KEY = '{self.key}';\nexport const SESSION_KEY = 'sb-{'a' * 20}-auth-token';"
    def test_matching_public_configuration(self):
        self.assertEqual(validate(self.env, self.source)["L4_ADMIN_EMAIL"], "synthetic-exception")
    def test_missing_and_placeholder_values(self):
        for env in ({}, {**self.env, "L4_SUPABASE_URL": "https://example.supabase.co"},
                    {**self.env, "L4_SUPABASE_PUBLISHABLE_KEY": "build-only-placeholder"}):
            with self.assertRaises(ValueError): validate(env, self.source)
    def test_secrets_and_legacy_tokens_rejected(self):
        for key in ("sb_secret_" + "x"*24, "service_role", "eyJhbGciOiJIUzI1NiJ9"):
            with self.assertRaises(ValueError): validate({**self.env, "L4_SUPABASE_PUBLISHABLE_KEY":key}, self.source)
    def test_missing_exception_cannot_silently_change_behavior(self):
        for value in ("", "   "):
            with self.assertRaises(ValueError): validate({**self.env, "L4_ADMIN_EMAIL":value}, self.source)
    def test_wrong_project_and_storage_rejected(self):
        for source in (self.source.replace(self.url, self.url.replace("a", "b")),
                       self.source.replace("auth-token", "wrong-token"), ""):
            with self.assertRaises(ValueError): validate(self.env, source)

if __name__ == "__main__": unittest.main()
