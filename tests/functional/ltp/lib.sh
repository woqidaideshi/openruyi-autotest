# library-prefix = ltp
#
# LTP suite-level shared library
# Uses flag-file + reference counting to ensure LTP is installed
# only ONCE across all test cases.
#
# Strategy:
#   1. Try dnf install (fast if package is in repo)
#   2. If dnf fails or runltp not found, compile from source
#
# Usage: . "$(dirname "$0")/../../lib.sh"; ltpSetup

LTP_FLAG="/tmp/.beakerlib_ltp_suite"
LTP_INSTALL_DIR="/opt/ltp-src"

_ltpEnsureBinLinks() {
    # runltp expects ltp-pan at $LTPROOT/bin/ltp-pan
    if [ ! -e "$LTP_INSTALL_DIR/bin/ltp-pan" ] && [ -x "$LTP_INSTALL_DIR/pan/ltp-pan" ]; then
        mkdir -p "$LTP_INSTALL_DIR/bin"
        ln -sf "$LTP_INSTALL_DIR/pan/ltp-pan" "$LTP_INSTALL_DIR/bin/ltp-pan"
    fi
    # runltp expects test binaries in $LTPROOT/testcases/bin/
    if [ ! -d "$LTP_INSTALL_DIR/testcases/bin" ] || [ "$(ls -A "$LTP_INSTALL_DIR/testcases/bin" 2>/dev/null)" = "" ]; then
        mkdir -p "$LTP_INSTALL_DIR/testcases/bin"
        find "$LTP_INSTALL_DIR/testcases" -type f -executable -exec ln -sf {} "$LTP_INSTALL_DIR/testcases/bin/" \; 2>/dev/null || true
    fi
}

_ltpSetupPath() {
    export PATH="$LTP_INSTALL_DIR:$LTP_INSTALL_DIR/pan:$LTP_INSTALL_DIR/testcases/bin:$PATH"
    export LTPROOT="$LTP_INSTALL_DIR"
}

ltpSetup() {
    if [ ! -f "$LTP_FLAG" ]; then
        local method=""
        # Check if any working LTP exists
        if command -v runltp >/dev/null 2>&1; then
            method="system"
            echo "installed=0" > "$LTP_FLAG"
        elif [ -x "$LTP_INSTALL_DIR/runltp" ]; then
            _ltpSetupPath
            _ltpEnsureBinLinks
            method="source-cached"
            echo "installed=0" > "$LTP_FLAG"
        else
            rlLogInfo "安装 LTP（首次）..."
            # Try dnf first
            if echo openruyi | sudo -S dnf install -y ltp 2>/dev/null && command -v runltp >/dev/null 2>&1; then
                method="dnf"
                echo "installed=1" > "$LTP_FLAG"
            else
                # dnf failed or runltp not in PATH — compile from source
                rlLogInfo "dnf 安装失败或无 runltp，从源码编译..."
                echo openruyi | sudo -S dnf install -y git make gcc gcc-c++ autoconf automake pkgconfig 2>/dev/null || true
                if [ ! -d "$LTP_INSTALL_DIR" ]; then
                    git clone --depth 1 --branch 20240524 https://github.com/linux-test-project/ltp.git "$LTP_INSTALL_DIR" 2>/dev/null || true
                fi
                if [ -f "$LTP_INSTALL_DIR/Makefile" ]; then
                    cd "$LTP_INSTALL_DIR" && make autotools && ./configure --prefix="$LTP_INSTALL_DIR" && make -j$(nproc) && sudo make install 2>&1 | tail -3
                fi
                _ltpSetupPath
                _ltpEnsureBinLinks
                if command -v runltp >/dev/null 2>&1; then
                    method="source"
                    echo "installed=2" > "$LTP_FLAG"
                else
                    rlLogWarning "LTP 源码编译失败，测试可能无法执行"
                    method="failed"
                    echo "installed=3" > "$LTP_FLAG"
                fi
            fi
        fi
        echo "ref=1" >> "$LTP_FLAG"
        rlLogInfo "LTP 安装方式: $method"
    else
        local ref
        ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP 已安装，引用计数: $ref"
        # Restore PATH if source install
        if [ -x "$LTP_INSTALL_DIR/runltp" ]; then
            _ltpSetupPath
            _ltpEnsureBinLinks
        fi
    fi

    rlCleanupAppend "ltpCleanup"
}

ltpCleanup() {
    if [ ! -f "$LTP_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$LTP_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        local installed
        installed=$(grep "^installed=" "$LTP_FLAG" | cut -d= -f2)
        case "$installed" in
            1) echo openruyi | sudo -S dnf remove -y ltp 2>/dev/null || true
               rlLogInfo "已卸载 LTP（dnf 安装）" ;;
            2) rm -rf "$LTP_INSTALL_DIR"
               rlLogInfo "已删除 LTP 源码目录" ;;
        esac
        rm -f "$LTP_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$LTP_FLAG"
        rlLogInfo "LTP 保留（还有 $ref 个测试未完成）"
    fi
}
