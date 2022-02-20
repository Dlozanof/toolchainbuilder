#!/bin/bash
# Validate toolchain repo. Please note this will leave traces in bazel cache, and is recommended to run
# bazelisk clean --expunge inside the repo_validation folder to clean everything up once tests are done.

echo "Generating files"
mkdir repo_validation
cd repo_validation

echo """
#include <iostream>
int main() { std::cout << \"It is working correctly\" << std::endl;}
""" > main.cpp

echo """
# Get this external repository
load(\"@bazel_tools//tools/build_defs/repo:git.bzl\", \"git_repository\")

git_repository(
    name = \"toolchain_builder\",
    commit = \"ba994c9c064c26cc2e55d6388be277a1582c56df\", # Put the commit of interest
    remote = \"https://github.com/Dlozanof/toolchainbuilder.git\",
)

# Load the build_toolchain() rule from toolchain_builder, previously obtained
load(\"@toolchain_builder//:deps.bzl\", \"build_toolchain\")

# Create the toolchain, in the future more parameters will be available
build_toolchain(
    name = \"gcc_toolchain\",
    compiler = \"gcc\",
)
""" > WORKSPACE

echo """
cc_binary(
    name = \"main\",
    srcs = [\"main.cpp\"]
)
""" > BUILD

echo """
build:gcc_config --crosstool_top=@gcc_toolchain//:gcc_suite
""" > .bazelrc

echo "Getting bazelisk"
wget https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-linux-amd64 -O bazelisk
chmod +x bazelisk

echo "Building toolchain and binary"
./bazelisk run --config=gcc_config :main
