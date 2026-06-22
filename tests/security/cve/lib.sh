# library-prefix = security_cve
#
# Security CVE suite-level shared library
# Uses flag-file + reference counting to ensure LTP
# is installed only ONCE and uninstalled only ONCE across all
# CVE test cases.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_cve-*/ subdirectories

CVE_FLAG="/tmp/.beakerlib_cve_suite"
LTP_DIR="/opt/ltp"

cveSetup() {
    if [ ! -f "$CVE_FLAG" ]; then
        if [ ! -f "$LTP_DIR/runltp" ]; then
            if command -v dnf >/dev/null 2>&1; then
                echo openruyi | sudo -S dnf install -y ltp 2>/dev/null && {
                    echo "installed=1" > "$CVE_FLAG"
                    rlLogInfo "已安装 LTP 软件包（首次）"
                    echo "ref=1" >> "$CVE_FLAG"
                    rlCleanupAppend "cveCleanup"
                    return 0
                }
            fi
            # Try building from source as fallback
            rlLogWarning "LTP 未安装（dnf 失败），尝试从源码编译..."
            cd /tmp
            rm -rf ltp
            if git clone --depth 1 https://github.com/linux-test-project/ltp.git 2>/dev/null; then
                cd ltp && make autotools && ./configure && make -j$(nproc) && sudo make install
                echo "installed=1" > "$CVE_FLAG"
            else
                echo "installed=0" > "$CVE_FLAG"
                rlLogWarning "LTP 安装失败，CVE 测试将被跳过"
            fi
        else
            echo "installed=0" > "$CVE_FLAG"
            rlLogInfo "LTP 已存在"
        fi
        echo "ref=1" >> "$CVE_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$CVE_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$CVE_FLAG"
        rlLogInfo "LTP 已由其他测试安装，引用计数: $ref"
    fi
    rlCleanupAppend "cveCleanup"
}

cveCleanup() {
    if [ ! -f "$CVE_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$CVE_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$CVE_FLAG"; then
            echo openruyi | sudo -S dnf remove -y ltp 2>/dev/null || true
            rlLogInfo "已卸载 LTP 软件包（最后一个测试）"
        fi
        rm -f "$CVE_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$CVE_FLAG"
        rlLogInfo "LTP 保留（还有 $ref 个测试未完成）"
    fi
}