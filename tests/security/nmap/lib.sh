# library-prefix = security_nmap
#
# Security Nmap suite-level shared library
# Uses flag-file + reference counting to ensure nmap
# is installed only ONCE and uninstalled only ONCE across all
# test cases, regardless of execution mode (sequential or parallel).
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_nmap_xxx/ subdirectories

NMAP_FLAG="/tmp/.beakerlib_nmap_suite"

nmapSetup() {
    if [ ! -f "$NMAP_FLAG" ]; then
        if ! rpm -q nmap 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y nmap 2>/dev/null
            echo "installed=1" > "$NMAP_FLAG"
            rlLogInfo "已安装 nmap 软件包（首次）"
        else
            echo "installed=0" > "$NMAP_FLAG"
            rlLogInfo "nmap 软件包已存在"
        fi
        echo "ref=1" >> "$NMAP_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$NMAP_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$NMAP_FLAG"
        rlLogInfo "nmap 已由其他测试安装，引用计数: $ref"
    fi
    rlCleanupAppend "nmapCleanup"
}

nmapCleanup() {
    if [ ! -f "$NMAP_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$NMAP_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$NMAP_FLAG"; then
            echo openruyi | sudo -S dnf remove -y nmap 2>/dev/null || true
            rlLogInfo "已卸载 nmap 软件包（最后一个测试）"
        fi
        rm -f "$NMAP_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$NMAP_FLAG"
        rlLogInfo "nmap 保留（还有 $ref 个测试未完成）"
    fi
}