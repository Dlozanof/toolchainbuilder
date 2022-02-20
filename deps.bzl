
def _build_toolchain_impl(ctx):
    ctx.report_progress("Getting files")

    # This is just a copy
    ctx.template("setup.sh", ctx.attr._setup_tpl)
    ctx.template("Dockerfile", ctx.attr._dockerfile)
    ctx.template("build.sh", ctx.attr._build_sh)
    ctx.template("BUILD.bazel", ctx.attr._build_tpl)
    ctx.template("cc_toolchain_config.bzl", ctx.attr._cc_toolchain_config)
    
    #repo_path = str(ctx.path(""))
    #ctx.template("cc_toolchain_config.bzl", ctx.attr._cc_toolchain_config_tpl,
    #    substitutions = {
    #        "%{repo_path}": repo_path,
    #    }
    #)

    retval = ctx.execute(["./setup.sh"], 3000, {}, False, "")
    print("Building toolchain")


build_toolchain = repository_rule(
    implementation = _build_toolchain_impl,
    attrs = {
        "compiler": attr.string(mandatory = True),
        "_setup_tpl": attr.label(default = "//:setup.sh"),
        "_dockerfile": attr.label(default = "//:Dockerfile"),
        "_build_sh": attr.label(default = "//:build.sh"),
        "_build_tpl": attr.label(default = "//:BUILD.bazel"),
        "_cc_toolchain_config": attr.label(default = "//:cc_toolchain_config.bzl"),
    },
)
