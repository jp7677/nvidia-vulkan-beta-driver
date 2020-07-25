#!/bin/sh
set -e

if [ -z "$VERSION" ]; then
    echo "Please specify VERSION to use this script."
    exit 1
fi

[[ -f NVIDIA-Linux-x86_64-${VERSION}.run ]] || wget -c https://developer.nvidia.com/vulkan-beta-${VERSION//./}-linux -O NVIDIA-Linux-x86_64-${VERSION}.run
[[ -f nvidia-driver-${VERSION}-x86_64.tar.xz ]] || sh nvidia-driver/nvidia-generate-tarballs.sh

ln -s $PWD/nvidia-driver-$VERSION-{x86_64,i386}.tar.xz nvidia-driver/
ln -s $PWD/nvidia-kmod-$VERSION-x86_64.tar.xz nvidia-kmod/
ln -s $PWD/nvidia-kmod-$VERSION-x86_64.tar.xz dkms-nvidia/

sed -i "s/Version:.*/Version:$VERSION/" nvidia-driver/nvidia-driver.spec nvidia-kmod-common/nvidia-kmod-common.spec nvidia-kmod/nvidia-kmod.spec dkms-nvidia/dkms-nvidia.spec

mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SRPMS}
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-driver" --define "_specdir $PWD/nvidia-driver" -bb nvidia-driver/nvidia-driver.spec --clean --target i386
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-driver" --define "_specdir $PWD/nvidia-driver" -bb nvidia-driver/nvidia-driver.spec --clean
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-kmod-common" --define "_specdir $PWD/nvidia-kmod-common" -bb nvidia-kmod-common/nvidia-kmod-common.spec --clean
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-kmod" --define "_specdir $PWD/nvidia-kmod" -bb nvidia-kmod/nvidia-kmod.spec --clean
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/dkms-nvidia" --define "_specdir $PWD/dkms-nvidia" -bb dkms-nvidia/dkms-nvidia.spec --clean

git submodule foreach git clean -d -f
git submodule foreach git checkout -- *.spec
