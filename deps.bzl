
def _toolchain_native_gcc_impl(ctx):
    ctx.report_progress("Getting files")

    ctx.template("setup.sh", ctx.attr._setup_tpl)
    ctx.template("Dockerfile", ctx.attr._dockerfile)
    ctx.template("build.sh", ctx.attr._build_sh,
        substitutions = {
            "%{gcc_version}": ctx.attr.version,
        }
    )
    ctx.template("BUILD.bazel", ctx.attr._build_tpl)
    ctx.template("cc_toolchain_gcc_native_config.bzl", ctx.attr._cc_toolchain_config)
    
    retval = ctx.execute(["./setup.sh"], 3000, {}, False, "")


toolchain_native_gcc = repository_rule(
    implementation = _toolchain_native_gcc_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "_setup_tpl": attr.label(default = "//:setup.sh"),
        "_dockerfile": attr.label(default = "//:Dockerfile"),
        "_build_sh": attr.label(default = "//:build.sh"),
        "_build_tpl": attr.label(default = "//:BUILD_GCC.bazel"),
        "_cc_toolchain_config": attr.label(default = "//:cc_toolchain_gcc_native_config.bzl"),
    },
)
