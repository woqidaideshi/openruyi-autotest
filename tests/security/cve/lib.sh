# library-prefix = security_cve
#
# Security CVE suite-level shared library
# Uses flag-file + reference counting to ensure LTP
# is installed only ONCE and uninstalled only ONCE across all
# CVE test cases.
#
# Strategy:
#   1. Try dnf install (fast if package is in repo)
#   2. If dnf fails or kirk not found, compile from source (tag 20260529)
#
# Reference: https://github.com/linux-test-project/ltp
# Usage:
#   . "$(dirname "$0")/../lib.sh"    # from test_cve-*/ subdirectories
#   cveSetup; _ltpRunCase cve cve-XXXX-XXXXX; cveCleanup (auto via rlCleanupAppend)

CVE_FLAG="/tmp/.beakerlib_security_cve_suite"
LTP_INSTALL_DIR="/opt/ltp"
LTP_TAG="20260529"

_cveSetupPath() {
    export PATH="$LTP_INSTALL_DIR:$LTP_INSTALL_DIR/tools:$PATH"
    export LTPROOT="$LTP_INSTALL_DIR"
}

# Run a single LTP test case via kirk or runltp and report result to BeakerLib.
# Pass / Fail / Skip are correctly mapped to tmt result states.
# Usage: _ltpRunCase <suite> <case>
_ltpRunCase() {
    local suite="$1"
    local case="$2"
    local out="/tmp/ltp_out_$$"

    # Try kirk first (newer LTP), fall back to runltp (older LTP)
    if command -v kirk >/dev/null 2>&1; then
        kirk -f "$suite" -p "$case" 2>&1 | tee "$out"
    elif command -v runltp >/dev/null 2>&1; then
        # runltp may be a stub ("runltp was removed from LTP") in newer LTP
        if runltp 2>&1 | grep -q "runltp was removed"; then
            rlFail "LTP runner: runltp is a stub, need kirk (LTP >= 2026)"
            return 1
        fi
        runltp -f "$suite" -s "$case" -q 2>&1 | tee "$out"
    else
        rlFail "LTP runner not found (kirk or runltp)"
        return 1
    fi
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ]; then
        rlFail "LTP 用例执行失败 (kirk exit=$rc)"
        rm -f "$out"
        return 1
    fi

    # All skipped, nothing actually passed — map to tmt SKIP
    if grep -qE 'Passed:[[:space:]]*0' "$out" && \
       grep -qE 'Skipped:[[:space:]]*[1-9]' "$out" && \
       grep -qE 'Failed:[[:space:]]*0' "$out" && \
       grep -qE 'Broken:[[:space:]]*0' "$out"; then
        rlTestSkip "LTP 用例被跳过（环境不支持）"
        rm -f "$out"
        return 0
    fi

    # Has failures or broken — map to tmt FAIL
    if grep -qE 'Failed:[[:space:]]*[1-9]' "$out" || \
       grep -qE 'Broken:[[:space:]]*[1-9]' "$out"; then
        rlFail "LTP 用例存在失败或损坏"
        rm -f "$out"
        return 1
    fi

    # All good (pass, possibly with some skipped)
    rlPass "LTP 用例通过"
    rm -f "$out"
    return 0
}

cveSetup() {
    if [ ! -f "$CVE_FLAG" ]; then
        local method=""
        # Check if any working LTP exists (kirk or runltp)
        if command -v kirk >/dev/null 2>&1 || command -v runltp >/dev/null 2>&1; then
            method="system"
            echo "installed=0" > "$CVE_FLAG"
        elif [ -x "$LTP_INSTALL_DIR/runltp" ] || [ -x "$LTP_INSTALL_DIR/kirk" ]; then
            # Detect incomplete build: runltp is a stub (LTP >= 2026) and kirk is missing
            if [ -x "$LTP_INSTALL_DIR/runltp" ] && grep -q "runltp was removed" "$LTP_INSTALL_DIR/runltp" 2>/dev/null && ! command -v kirk >/dev/null 2>&1 && [ ! -x "$LTP_INSTALL_DIR/kirk" ]; then
                rlLogWarning "LTP 构建不完整（runltp 是存根且 kirk 未编译），强制重新安装"
                rm -rf "$LTP_INSTALL_DIR"
                # Fall through to fresh install path below
            else
                _cveSetupPath
                method="source-cached"
                echo "installed=0" > "$CVE_FLAG"
            fi
        fi
        # If LTP_INSTALL_DIR was removed above, re-enter fresh install path
        if [ ! -f "$CVE_FLAG" ] && [ ! -d "$LTP_INSTALL_DIR" ]; then
            rlLogInfo "安装 LTP（首次）..."
            # Try dnf first
            if echo openruyi | sudo -S dnf install -y ltp 2>/dev/null && command -v kirk >/dev/null 2>&1; then
                method="dnf"
                echo "installed=1" > "$CVE_FLAG"
            else
                # dnf failed or kirk not in PATH — compile from source
                rlLogInfo "dnf 安装失败或无 kirk，从源码编译（tag: $LTP_TAG）..."
                echo openruyi | sudo -S dnf install -y git make gcc gcc-c++ autoconf automake pkgconfig \
                    zlib-devel keyutils-libs-devel libtirpc-devel libmnl-devel libaio-devel \
                    libcap-devel openssl-devel numactl-devel 2>/dev/null || true
                if [ ! -d "$LTP_INSTALL_DIR" ]; then
                    echo openruyi | sudo -S mkdir -p "$LTP_INSTALL_DIR" 2>/dev/null
                    echo openruyi | sudo -S chown openruyi:openruyi "$LTP_INSTALL_DIR" 2>/dev/null
                    git clone --depth 1 --branch "$LTP_TAG" https://github.com/linux-test-project/ltp.git "$LTP_INSTALL_DIR" 2>/dev/null || true
                fi
                if [ -f "$LTP_INSTALL_DIR/Makefile" ]; then
                    # Fix: riscv64 glibc already defines struct sched_attr /
                    # sched_setattr / sched_getattr (conflicting with lapi/sched.h).
                    # Wrap the LTP fallback with #ifndef guards.
                    local sched_h="$LTP_INSTALL_DIR/include/lapi/sched.h"
                    if [ -f "$sched_h" ] && grep -q 'struct sched_attr' "$sched_h" 2>/dev/null; then
                        sed -i '/^struct sched_attr {/,/^};/s/^/\/\//' "$sched_h"
                        sed -i '/^static inline int sched_setattr/,/^}/s/^/\/\//' "$sched_h"
                        sed -i '/^static inline int sched_getattr/,/^}/s/^/\/\//' "$sched_h"
                    fi
                    cd "$LTP_INSTALL_DIR" && make autotools && ./configure --prefix="$LTP_INSTALL_DIR" --with-open-posix-testsuite && make -j$(nproc) -k || true
                    # Install whatever was built (kirk + test binaries). Some
                    # test binaries may be missing due to kernel header
                    # incompatibilities on riscv64, but kirk works fine.
                    sudo make install 2>&1 | tail -3 || true
                fi
                _cveSetupPath
                # Check for kirk first (required for LTP >= 2026).
                # runltp may be a leftover stub from dnf, don't trust it alone.
                if command -v kirk >/dev/null 2>&1; then
                    method="source"
                    echo "installed=2" > "$CVE_FLAG"
                elif [ -x "$LTP_INSTALL_DIR/tools/kirk" ]; then
                    # kirk was built but make install failed — install manually
                    cp -a "$LTP_INSTALL_DIR/tools/kirk" "$LTP_INSTALL_DIR/" 2>/dev/null || true
                    _cveSetupPath
                    if command -v kirk >/dev/null 2>&1; then
                        method="source"
                        echo "installed=2" > "$CVE_FLAG"
                    else
                        rlLogWarning "LTP 源码编译成功但 kirk 安装失败，测试可能无法执行"
                        method="failed"
                        echo "installed=3" > "$CVE_FLAG"
                    fi
                elif command -v runltp >/dev/null 2>&1; then
                    # Fallback: only rely on runltp (older LTP, pre-2026)
                    method="source-legacy"
                    echo "installed=2" > "$CVE_FLAG"
                else
                    rlLogWarning "LTP 源码编译失败，测试可能无法执行"
                    method="failed"
                    echo "installed=3" > "$CVE_FLAG"
                fi
            fi
        fi
        echo "ref=1" >> "$CVE_FLAG"
        rlLogInfo "LTP 安装方式: $method"
    else
        local ref
        ref=$(grep "^ref=" "$CVE_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$CVE_FLAG"
        rlLogInfo "LTP 已安装，引用计数: $ref"
        # Restore PATH if source install
        if [ -x "$LTP_INSTALL_DIR/runltp" ] || [ -x "$LTP_INSTALL_DIR/kirk" ]; then
            _cveSetupPath
        fi
    fi

    rlCleanupAppend "cveCleanup"
}

cveCleanup() {
    if [ ! -f "$CVE_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$CVE_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        local installed
        installed=$(grep "^installed=" "$CVE_FLAG" | cut -d= -f2)
        case "$installed" in
            1) echo openruyi | sudo -S dnf remove -y ltp 2>/dev/null || true
               rlLogInfo "已卸载 LTP（dnf 安装）" ;;
            2) rm -rf "$LTP_INSTALL_DIR"
               rlLogInfo "已删除 LTP 源码目录" ;;
        esac
        rm -f "$CVE_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$CVE_FLAG"
        rlLogInfo "LTP 保留（还有 $ref 个测试未完成）"
    fi
}