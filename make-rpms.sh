#!/bin/sh
set -e

if [ -z "$VERSION" ]; then
    echo "Please specify VERSION to use this script."
    exit 1
fi

[[ -f NVIDIA-Linux-x86_64-${VERSION}.run ]] || wget -c https://developer.nvidia.com/vulkan-beta-${VERSION//./}-linux -O NVIDIA-Linux-x86_64-${VERSION}.run
[[ -f nvidia-driver-${VERSION}-x86_64.tar.xz ]] || sh nvidia-driver/nvidia-generate-tarballs.sh

git submodule foreach '\
    sed -i "s/Version:.*/Version:$VERSION/" $name.spec && \
    ln -s ../nvidia-driver-$VERSION-{x86_64,i386}.tar.xz ../nvidia-kmod-$VERSION-x86_64.tar.xz .'

mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SRPMS}
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-driver" --define "_specdir $PWD/nvidia-driver" --clean --target i386 -bb nvidia-driver/nvidia-driver.spec
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-driver" --define "_specdir $PWD/nvidia-driver" --clean -bb nvidia-driver/nvidia-driver.spec
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-kmod-common" --define "_specdir $PWD/nvidia-kmod-common" --clean -bb nvidia-kmod-common/nvidia-kmod-common.spec
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/nvidia-kmod" --define "_specdir $PWD/nvidia-kmod" --clean -bb nvidia-kmod/nvidia-kmod.spec
rpmbuild --define "_topdir $PWD/rpmbuild" --define "_sourcedir $PWD/dkms-nvidia" --define "_specdir $PWD/dkms-nvidia" --clean -bb dkms-nvidia/dkms-nvidia.spec

git submodule foreach '\
    git checkout -- $name.spec && \
    rm nvidia-driver-$VERSION-{x86_64,i386}.tar.xz nvidia-kmod-$VERSION-x86_64.tar.xz'
