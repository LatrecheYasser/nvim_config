# Neovim

## Java with Bazel

Prerequisites on macOS:

```sh
brew install jdtls openjdk@25 buildifier
```

`bzl` and Python 3.9+ must also be on `PATH`. The configuration finds Homebrew's
JDK 25 automatically; set `NVIM_JAVA_HOME` to override it.

Open a Java file normally. On the first visit to its Bazel package, Neovim builds
that package's Java library/binary/test targets and resolves their classpaths
with `bzl cquery`. JDTLS then supplies completion, diagnostics, navigation,
refactoring, and formatting through the existing LSP mappings. Subsequent visits
reuse the cached project and index.

Main, test, and benchmark source roots, annotation-processor-generated sources,
dependency jars (including compile-only dependencies), and source jars are
included. Eclipse metadata and JDTLS output live under `stdpath("cache")`, keyed
by the absolute module path so different worktrees have separate indexes.
The repository's Eclipse GoogleStyle formatter and two-space indentation are
used for Bazel Java buffers.

| Command / mapping | Action |
| --- | --- |
| `:BazelJavaSync` | Rebuild the module and refresh its dependencies/generated sources |
| `:BazelJavaSync //path/to/module:target` | Sync explicit Java targets in the current module |
| `:BazelJavaLog` | View sync output, including authentication prompts |
| `<leader>jo` | Organize Java imports |
| `:BazelBuild` / `<leader>bb` | Build the current module's Java targets |
| `:BazelTest` / `<leader>bt` | Run tests in the current Bazel package |
| `:BazelTestFile` / `<leader>bf` | Run the current Java test class |
| `:BazelFormat` | Run the repo's Java formatter, or buildifier for BUILD/.bzl files |

Build/test commands save the current buffer and run in a terminal split with the
workspace root as their working directory. They accept explicit targets and flags,
for example `:BazelTest //path:tests --test_filter=MyTest#methodName`. Default test
scope is `:all --build_tests_only`; default builds select Java targets rather than
deployment/image targets. Java and Starlark Tree-sitter parsers are installed.

Run `:BazelJavaSync` after changing BUILD dependencies, generated code, or branches,
or after `bzl clean`. A failed Bazel build keeps the previous cached project. First-time
sync requires a successful Bazel build; fix compilation or authentication issues
shown in the log, then retry.

Indexing and references are module-scoped. Main and test dependencies are combined
for editor assistance; Bazel remains authoritative for strict dependency checks,
annotation processing, Error Prone/NullAway, and test execution.

Exporter regression checks:

```sh
python3 -B -m unittest discover -s tests
```
