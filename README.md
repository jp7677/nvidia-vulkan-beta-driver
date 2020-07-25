# [NVIDIA Vulkan Beta Driver](https://github.com/jp7677/nvidia-vulkan-beta-driver)

This is just a script to build packages of the [NVIDIA Vulkan Beta Driver](https://developer.nvidia.com/vulkan-driver) for Fedora 32. This script just wraps the excellent NVIDIA package scripts from [negativo17](https://negativo17.org/).

Building rpm's with:

```bash
git clone --recurse-submodules https://github.com/jp7677/nvidia-vulkan-beta-driver
cd nvidia-vulkan-beta-driver
VERSION=450.56.02 ./make-rpms.sh
```

Installing by running as root:

```bash
VERSION=450.56.02;dnf install \
  rpmbuild/RPMS/noarch/nvidia-kmod-common-$VERSION-1.fc32.noarch.rpm \
  rpmbuild/RPMS/x86_64/dkms-nvidia-$VERSION-1.fc32.x86_64.rpm \
  rpmbuild/RPMS/x86_64/nvidia-driver-$VERSION-1.fc32.x86_64.rpm \
  rpmbuild/RPMS/x86_64/nvidia-driver-libs-$VERSION-1.fc32.x86_64.rpm \
  rpmbuild/RPMS/x86_64/nvidia-driver-cuda-libs-$VERSION-1.fc32.x86_64.rpm \
  rpmbuild/RPMS/i386/nvidia-driver-libs-$VERSION-1.fc32.i386.rpm \
  rpmbuild/RPMS/i386/nvidia-driver-cuda-libs-$VERSION-1.fc32.i386.rpm
```

Obviously you would need to replace the version number with your prefered version.

Optionally enable NVIDIA modeset by running as root:

```bash
grubby --args="nvidia-drm.modeset=1" --update-kernel=ALL
```
Or alternatively follow https://negativo17.org/wayland-modesetting-on-nvidia/

Thanks a lot [scaronni](https://github.com/scaronni) for all the hard work.
