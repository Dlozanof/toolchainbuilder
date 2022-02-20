# Toolchain builder
This repository provides a Bazel rule that allows creating a standalone toolchain for a project. Currently a native toolchain is used, that is, it depends on the headers of the system it is created. It has several benefits as compared with using the system's one:
- Having several toolchains of different versions of a compiler in the same machine.
- Building the toolchain exactly as desired.
- If the system toolchain is very outdated, this allows having a recent version.

*Note:*
In the future, totally hermetic toolchains will be supported.

## Requirements
This will use docker to build the toolchain in a container, so no dependencies are needed in the host system. But this means that docker must be available on the system.

## How to use it
Put this in your WORKSPACE:

```
# Get this external repository
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "toolchain_builder",
    commit = "ba994c9c064c26cc2e55d6388be277a1582c56df", # Put the commit of interest
    remote = "https://github.com/Dlozanof/toolchainbuilder.git",
)

# Load the build_toolchain() rule from toolchain_builder, previously obtained
load("@toolchain_builder//:deps.bzl", "build_toolchain")

# Create the toolchain, in the future more parameters will be available
build_toolchain(
    name = "gcc_toolchain",
    compiler = "gcc",
)
```

For using it, create a .bazelrc file the same place as the WORKSPACE file and fill it with the following:
```
build:gcc_config --crosstool_top=@gcc_toolchain//:gcc_suite
```

This will associate the --config=gcc_config used in bazel commands with the --crosstool_top option, which will make Bazel use the created toolchain. Example:
```
bazel run --config=gcc_config :main
```

## Validating
If you want to check everything is ok, the following one liner will automatically create a new folder with a dummy main.cpp file and will setup the toolchain and try to run the target //:main that will do a print if everything works fine:

wget version:
```
sh -c "$(wget https://raw.githubusercontent.com/Dlozanof/toolchainbuilder/master/validate_repo.sh -O -)"
```
curl version
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Dlozanof/toolchainbuilder/master/validate_repo.sh)"
```
