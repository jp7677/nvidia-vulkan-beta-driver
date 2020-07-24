#!/bin/sh
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
export VERSION=${VERSION:-450.56.02}

pushd nvidia-driver
wget -c https://developer.nvidia.com/vulkan-beta-${VERSION//./}-linux -O NVIDIA-Linux-x86_64-${VERSION}.run
sh nvidia-generate-tarballs.sh
sed -i "s/Version:.*/Version:$VERSION/" nvidia-driver.spec
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" -bb nvidia-driver.spec --clean --target i386
rpmbuild --define "_topdir $PWD/../rpmbuild" --define "_sourcedir $PWD" -bb nvidia-driver.spec --clean
git checkout -- nvidia-driver.spec
git clean -d -f
popd
