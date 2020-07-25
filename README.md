# NVIDIA Vulkan Beta Driver

Building rpm's with:

```bash
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

Enabling NVIDIA modeset by running as root:

```bash
grubby --args="nvidia-drm.modeset=1" --update-kernel=ALL
```
