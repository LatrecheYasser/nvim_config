import importlib.util
from pathlib import Path
import tempfile
import unittest
import xml.etree.ElementTree as ET
import zipfile

spec = importlib.util.spec_from_file_location("bazel_java", Path(__file__).parents[1] / "scripts/bazel_java.py")
bazel_java = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bazel_java)


class BazelJavaTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def artifact(self, path):
        file = self.root / path
        file.parent.mkdir(parents=True, exist_ok=True)
        file.touch()
        return file

    def test_full_jars_replace_headers_but_keep_neverlink(self):
        full = self.artifact("deps/processed_guava.jar")
        self.artifact("deps/header_guava.jar")
        source = self.artifact("deps/guava-sources.jar")
        neverlink = self.artifact("annotations/header_annotations.jar")
        records = [{
            "runtime": ["deps/processed_guava.jar"],
            "compile": ["deps/header_guava.jar", "annotations/header_annotations.jar"],
            "sources": ["deps/guava-sources.jar"],
        }]
        self.assertEqual(bazel_java.classpath(records, self.root), [(full, source), (neverlink, None)])

    def test_missing_classpath_is_not_silently_accepted(self):
        with self.assertRaisesRegex(RuntimeError, "missing"):
            bazel_java.classpath([{"runtime": [], "compile": ["missing.jar"], "sources": []}], self.root)

    def test_generated_types_refresh_and_sources_stay_linked(self):
        module = self.root / "workspace" / "module"
        (module / "src/main/java").mkdir(parents=True)
        (module / "src/test/java").mkdir(parents=True)
        jar = self.root / "module-gensrc.jar"
        with zipfile.ZipFile(jar, "w") as archive:
            archive.writestr("com/example/ImmutableThing.java", "package com.example;")
            archive.writestr("../../escape.java", "unexpected")
        records = [{"runtime": [], "compile": [], "sources": [], "generated": [jar.name]}]
        project = self.root / "cache" / "project"
        bazel_java.export_project(module, project, records, self.root, "25")
        self.assertEqual(len(list(project.glob("generated/**/ImmutableThing.java"))), 1)
        self.assertFalse(list(self.root.rglob("escape.java")))
        self.assertFalse((module / ".project").exists())
        links = ET.parse(project / ".project").findall("linkedResources/link/locationURI")
        self.assertEqual({link.text for link in links}, {
            (module / "src/main/java").as_uri(), (module / "src/test/java").as_uri(),
        })
        records[0]["generated"] = []
        bazel_java.export_project(module, project, records, self.root, "25")
        self.assertFalse(list(project.glob("generated/**/*.java")))


if __name__ == "__main__":
    unittest.main()
