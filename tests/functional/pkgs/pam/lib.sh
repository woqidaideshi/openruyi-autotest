# library-prefix = pam
#
# pam suite-level shared library
# Uses flag-file + reference counting to ensure the package
# is installed only ONCE and uninstalled only ONCE across all
# test cases.

PKG_FLAG="/tmp/.beakerlib_pam_suite"

pamSetup() {
    if [ ! -f "$PKG_FLAG" ]; then
        if ! rpm -q pam 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y pam 2>/dev/null
            echo "installed=1" > "$PKG_FLAG"
            rlLogInfo "已安装 pam 软件包（首次）"
        else
            echo "installed=0" > "$PKG_FLAG"
            rlLogInfo "pam 软件包已存在"
        fi
        echo "ref=1" >> "$PKG_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
        rlLogInfo "pam 已由其他测试安装，引用计数: $ref"
    fi
    rlCleanupAppend "pamCleanup"
}

pamCleanup() {
    if [ ! -f "$PKG_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$PKG_FLAG"; then
            echo openruyi | sudo -S dnf remove -y pam 2>/dev/null || true
            rlLogInfo "已卸载 pam 软件包（最后一个测试）"
        fi
        rm -f "$PKG_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
        rlLogInfo "pam 保留（还有 $ref 个测试未完成）"
    fi
}
