# Kernel for Firecracker MicroVMs

This repository contains the files used to configure and build the upstream Linux
Kernel tweaked for use with Firecracker MicroVMs.

## Configuration fragments

The Linux Kernel can be configured using different ways. This repository uses a
set of fragments that get merged with the default `.config` file produced
non-interactively by the Makefile target `x86_64_defconfig`.

### How the initial configuration fragments file was produced

- Generated the default non-interactive `.config` file with:

```shell
make x86_64_defconfig
```

- Copied the unmodified file to a separate directory.
- Manually configured the `.config` using the Makefile target `menuconfig`.
- Created the `.config_fragments` file:

```shell
$ touch .config_fragments
# Copy all the modified configs that switched to `y`.
$ diff --unified <original_config> <modified_config> \
  | awk 'match($0, /^+(.*=y)/, g) { print g[1] }' \
  >> .config_fragments
# Copy all the modified configs that switched to `# CONFIG_* is not set`,
# replacing `is not set` by the `n` syntax.
$ diff --unified <original_config> <modified_config> \
  | awk 'match($0, /^+# (.*) is not set/, g) { printf("%s=n\n", g[1]) }' \
  >> .config_fragments
```
