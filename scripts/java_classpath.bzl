def format(target):
    java = None
    for name, value in providers(target).items():
        if name == "JavaInfo" or name.endswith("%JavaInfo"):
            java = value
            break
    if not java:
        return ""
    compilation = java.compilation_info
    return json.encode({
        "label": str(target.label),
        "runtime": [f.path for f in (
            compilation.runtime_classpath.to_list() if compilation else java.transitive_runtime_jars.to_list()
        )],
        "compile": [f.path for f in (
            compilation.compilation_classpath.to_list() if compilation else java.transitive_compile_time_jars.to_list()
        )],
        "sources": [f.path for f in java.transitive_source_jars.to_list()],
        "generated": [
            output.generated_source_jar.path
            for output in java.java_outputs
            if output.generated_source_jar
        ],
    })
