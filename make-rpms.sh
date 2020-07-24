#!/bin/sh
set -e

if [ -z "$VERSION" ]; then
    echo "Please specify VERSION to use this script."
    exit 1
fi

mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
[[ -f NVIDIA-Linux-x86_64-${VERSION}.run ]] || wget -c https://developer.nvidia.com/vulkan-beta-${VERSION//./}-linux -O NVIDIA-Linux-x86_64-${VERSION}.run

pushd nvidia-driver
cp -v ../NVIDIA-Linux-x86_64-${VERSION}.run .
sh nvidia-generate-tarballs.sh
sed -i "s/Version:.*/Version:$VERSION/" nvidia-driver.spec
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" -bb nvidia-driver.spec --clean --target i386
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" -bb nvidia-driver.spec --clean
popd

pushd nvidia-kmod-common
sed -i "s/Version:.*/Version:$VERSION/" nvidia-kmod-common.spec
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" -bb nvidia-kmod-common.spec --clean
popd

pushd nvidia-kmod
sed -i "s/Version:.*/Version:$VERSION/" nvidia-kmod.spec
cp -v ../nvidia-driver/nvidia-kmod-$VERSION-x86_64.tar.xz .
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" --define "_specdir $PWD" -bb nvidia-kmod.spec --clean
popd

pushd dkms-nvidia
sed -i "s/Version:.*/Version:$VERSION/" dkms-nvidia.spec
cp -v ../nvidia-driver/nvidia-kmod-$VERSION-x86_64.tar.xz .
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" -bb dkms-nvidia.spec --clean
popd

git submodule foreach --recursive git clean -d -f
git submodule foreach --recursive git reset --hard
