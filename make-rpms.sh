#!/bin/sh
set -e

if [ -z "$VERSION" ]; then
    echo "Please specify VERSION to use this script."
    exit 1
fi

[[ -f NVIDIA-Linux-x86_64-${VERSION}.run ]] || \
    wget -c https://developer.nvidia.com/vulkan-beta-${VERSION//./}-linux -O NVIDIA-Linux-x86_64-${VERSION}.run

[[ -f nvidia-driver-${VERSION}-x86_64.tar.xz ]] || \
    sh nvidia-driver/nvidia-generate-tarballs.sh

git submodule foreach '\
    sed -i "s/Version:.*/Version:$VERSION/" $name.spec && \
    ln -s ../nvidia-driver-$VERSION-{x86_64,i386}.tar.xz ../nvidia-kmod-$VERSION-x86_64.tar.xz .'

mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SRPMS}

build_rpm() {
    rpmbuild \
        --define "_topdir $PWD/rpmbuild" \
        --define "_sourcedir $PWD/$1" \
        --define "_specdir $PWD/$1" \
        --target $2 \
        --clean \
        -bb $1/$1.spec    
}

build_rpm nvidia-driver i386
build_rpm nvidia-driver x86_64
build_rpm nvidia-kmod-common x86_64
build_rpm nvidia-kmod x86_64
build_rpm dkms-nvidia x86_64

git submodule foreach '\
    git checkout -- $name.spec && \
    rm nvidia-driver-$VERSION-{x86_64,i386}.tar.xz nvidia-kmod-$VERSION-x86_64.tar.xz'
