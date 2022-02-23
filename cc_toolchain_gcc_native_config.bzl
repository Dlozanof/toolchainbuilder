load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
       "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
       "feature",
       "flag_group",
       "flag_set",
       "tool_path",
)

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "gcc",
            path = "toolchainroot/bin/x86_64-pc-linux-gnu-g++",
        ),
        tool_path(
            name = "ld",
            path = "toolchainroot/bin/bin/x86_64-pc-linux-gnu-ld",
        ),
        tool_path(
            name = "ar",
            path = "toolchainroot/bin/bin/x86_64-pc-linux-gnu-ar",
        ),
        tool_path(
            name = "cpp",
            path = "toolchainroot/bin/x86_64-pc-linux-gnu-g++",
        ),
        tool_path(
            name = "gcov",
            path = "/bin/false",
        ),
        tool_path(
            name = "nm",
            path = "/bin/false",
        ),
        tool_path(
            name = "objdump",
            path = "/bin/false",
        ),
        tool_path(
            name = "strip",
            path = "/bin/false",
        ),
    ]

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "-lstdc++",
                        ],
                    ),
                ]),
            ),
        ],
    )

    features = [
        feature(
            name = "default_compiler_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [ACTION_NAMES.cpp_compile],
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-no-canonical-prefixes",
                                "-fno-canonical-system-headers",
                            ],
                        ),
                    ]),
                ),
            ],
        ),
    ] 


    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        cxx_builtin_include_directories = [
            "/usr/include", # This is a native toolchain, it is NOT hermetic and WILL use computer libraries 
            "toolchainroot/include/c++/11.2.0",
            "toolchainroot/include/c++/11.2.0/parallel",
            "toolchainroot/lib/gcc/x86_64-pc-linux-gnu/11.2.0/include",
            "toolchainroot/lib/gcc/x86_64-pc-linux-gnu/11.2.0/include-fixed",
        ],
        toolchain_identifier = "k8-toolchain-native-gcc",
        host_system_name = "local",
        target_system_name = "local",
        target_cpu = "k8",
        target_libc = "unknown",
        compiler = "gcc",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
)

cc_toolchain_gcc_native_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
