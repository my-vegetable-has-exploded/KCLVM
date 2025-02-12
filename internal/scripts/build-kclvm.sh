#!/usr/bin/env bash

# Stop on error.
set -e

prepare_dirs () {
    kclvm_install_dir="$topdir/_build/dist/$os/kclvm"
    mkdir -p "$kclvm_install_dir/bin"
    mkdir -p "$kclvm_install_dir/lib/site-packages"
    mkdir -p "$kclvm_install_dir/include"
}

prepare_dirs

# Perform the build process.
set -x

# Copy KCLVM.
cp "$topdir/internal/scripts/cli/kcl" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kclvm" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kcl-plugin" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kcl-doc" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kcl-test" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kcl-lint" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kcl-fmt" $kclvm_install_dir/bin/
cp "$topdir/internal/scripts/cli/kcl-vet" $kclvm_install_dir/bin/
chmod +x $kclvm_install_dir/bin/kcl
chmod +x $kclvm_install_dir/bin/kclvm
chmod +x $kclvm_install_dir/bin/kcl-plugin
chmod +x $kclvm_install_dir/bin/kcl-doc
chmod +x $kclvm_install_dir/bin/kcl-test
chmod +x $kclvm_install_dir/bin/kcl-lint
chmod +x $kclvm_install_dir/bin/kcl-fmt
chmod +x $kclvm_install_dir/bin/kcl-vet

if [ -d $kclvm_install_dir/lib/site-packages/kclvm ]; then
   rm -rf $kclvm_install_dir/lib/site-packages/kclvm
fi

# Install plugins
cp -rf $topdir/plugins $kclvm_install_dir/

set +x

# Print the summary.
echo "================ Summary ================"
echo "  KCLVM is installed into $kclvm_install_dir"

# Run KCL CLI to install dependencies.
$kclvm_install_dir/bin/kclvm -m pip install kclvm --user
$kclvm_install_dir/bin/kcl
