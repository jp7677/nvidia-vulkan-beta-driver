# [NVIDIA Vulkan Beta Driver](https://github.com/jp7677/nvidia-vulkan-beta-driver)

This is a script to build packages of the [NVIDIA Vulkan Beta Driver](https://developer.nvidia.com/vulkan-driver) for Fedora 43. This script just wraps the excellent NVIDIA package scripts from [negativo17](https://negativo17.org/).

Warning: this is meant for personal use, use at your own risk.

## Build and install

You'll need to have `rpmbuild`, `kmodtool` and friends installed on your Fedora 43 machine. Building rpm's for e.g. driver version 580.94.06 goes like:

```bash
git clone --recurse-submodules https://github.com/jp7677/nvidia-vulkan-beta-driver
cd nvidia-vulkan-beta-driver
VERSION=595.44.05 ./make-rpms.sh
```

Installing by running (dry-run), you might need to adjust epoch versions:

```bash
VERSION=595.44.05;dnf install --allowerasing --assumeno \
  rpmbuild/RPMS/noarch/nvidia-kmod-common-$VERSION-1.fc43.noarch.rpm \
  rpmbuild/RPMS/noarch/dkms-nvidia-$VERSION-1.fc43.noarch.rpm \
  rpmbuild/RPMS/x86_64/nvidia-driver-$VERSION-1.fc43.x86_64.rpm \
  rpmbuild/RPMS/x86_64/nvidia-driver-libs-$VERSION-1.fc43.x86_64.rpm \
  rpmbuild/RPMS/x86_64/nvidia-driver-cuda-libs-$VERSION-1.fc43.x86_64.rpm \
  rpmbuild/RPMS/x86_64/libnvidia-cfg-$VERSION-1.fc43.x86_64.rpm \
  rpmbuild/RPMS/x86_64/libnvidia-gpucomp-$VERSION-1.fc43.x86_64.rpm \
  rpmbuild/RPMS/x86_64/libnvidia-ml-$VERSION-1.fc43.x86_64.rpm \
  rpmbuild/RPMS/i686/nvidia-driver-libs-$VERSION-1.fc43.i686.rpm \
  rpmbuild/RPMS/i686/nvidia-driver-cuda-libs-$VERSION-1.fc43.i686.rpm \
  rpmbuild/RPMS/i686/libnvidia-gpucomp-$VERSION-1.fc43.i686.rpm \
  rpmbuild/RPMS/i686/libnvidia-ml-$VERSION-1.fc43.i686.rpm
```

Obviously you would need to replace the version number with your prefered version.

Note that this builds and installs the driver only, there is no control panel or other extras. Please remove related packages like `nvidia-settings` and `nvidia-persistenced` before attempting to install above packages.

## Remove or downgrading

Use the following to remove the driver from your system (dry-run):

```bash
VERSION=595.44.05;dnf remove --noautoremove --assumeno \
  nvidia-kmod-common-$VERSION \
  dkms-nvidia-$VERSION \
  nvidia-driver-$VERSION \
  nvidia-driver-libs-$VERSION \
  nvidia-driver-cuda-libs-$VERSION \
  libnvidia-cfg-$VERSION \
  libnvidia-gpucomp-$VERSION \
  libnvidia-ml-$VERSION
```

Alternatively use this command to downgrade to another version (dry-run):

```bash
VERSION=595.45.04;dnf install --assumeno \
  nvidia-kmod-common-$VERSION \
  dkms-nvidia-$VERSION \
  nvidia-driver-$VERSION \
  nvidia-driver-libs-*:$VERSION*.x86_64 \
  nvidia-driver-cuda-libs-*:$VERSION*.x86_64 \
  nvidia-driver-libs-*:$VERSION*.i686 \
  nvidia-driver-cuda-libs-*:$VERSION*.i686
```

## Credits

Thanks a lot [scaronni](https://github.com/scaronni) for creating and maintaining the Negativo17 packages!
