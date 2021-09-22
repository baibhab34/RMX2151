#!/bin/bash

function compile() 
{

source ~/.bashrc && source ~/.profile
export USE_CCACHE=1
export ARCH=arm64
export KBUILD_BUILD_HOST=ubuntu
export KBUILD_BUILD_USER="Baibhab"
TANGGAL=$(date +"%F-%S")
git clone --depth=1 https://github.com/sarthakroy2002/android_prebuilts_clang_host_linux-x86_clang-6443078 clang
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 los-4.9-64
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 los-4.9-32

make O=out ARCH=arm64 RMX2151_defconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/los-4.9-32/bin:${PATH}:${PWD}/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all) O=out \
                      ARCH=arm64 \
                      CC="clang" \
                      CLANG_TRIPLE=aarch64-linux-gnu- \
                      CROSS_COMPILE="${PWD}/los-4.9-64/bin/aarch64-linux-android-" \
                      CROSS_COMPILE_ARM32="${PWD}/los-4.9-32/bin/arm-linux-androideabi-" \
                      CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
git clone https://gitlab.com/Baibhab34/AnyKernel3.git -b RMX2151 AnyKernel3
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3
cd AnyKernel3
zip -r9 Avalanche-RMX2151-${TANGGAL}.zip *
curl -sL https://git.io/file-transfer | sh
./transfer wet Avalanche-RMX2151-${TANGGAL}.zip
}

compile
zupload
