
#!/usr/bin/env bash

#

rp_module_id="citra"
rp_module_desc="3DS Emulator Citra"
rp_module_help="ROM Extension: .3ds\n\nCopy your 3DS roms to $romdir/3ds"
rp_module_licence="GPL2 https://github.com/citra-emu/citra/blob/master/license.txt"
rp_module_section="exp"
rp_module_flags="!arm"

function depends_citra() {
    if compareVersions $__gcc_version lt 7; then
        md_ret_errors+=("Sorry, you need an OS with gcc 7.0 or newer to compile citra")
        return 1
    fi

    # Additional libraries required for running
    local depends=(build-essential cmake clang clang-format libc++-dev libsdl2-dev qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev libfdk-aac-dev ffmpeg libswscale-dev libavformat-dev libavcodec-dev libavdevice-dev)
    getDepends "${depends[@]}"
}

function sources_citra() {
    gitPullOrClone "$md_build" https://github.com/citra-emu/citra.git
}

function build_citra() {
    cd "$md_build/citra"
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    make
    md_ret_require="$md_build/build/bin"

}

function install_citra() {
      md_ret_files=(
      'build/bin/Release/citra'
      'build/bin/Release/citra-qt'
      ''
      )

}

function configure_citra() {

    mkRomDir "3ds"
    ensureSystemretroconfig "3ds"
    addEmulator 0 "$md_id" "3ds" "$md_inst/citra %ROM%"
    addEmulator 1 "$md_id-qt" "3ds" "$md_inst/citra-qt %ROM%"
    addSystem "3ds"


}
