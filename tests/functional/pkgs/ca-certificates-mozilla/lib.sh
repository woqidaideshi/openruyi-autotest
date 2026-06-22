# library-prefix = ca_certificates_mozilla
#
# ca-certificates-mozilla suite-level shared library
# Uses flag-file + reference counting to ensure the package
# is installed only ONCE and uninstalled only ONCE across all
# test cases.

PKG_FLAG="/tmp/.beakerlib_ca_certificates_mozilla_suite"

caCertificatesMozillaSetup() {
    if [ ! -f "$PKG_FLAG" ]; then
        if ! rpm -q ca-certificates-mozilla 2>/dev/null; then
            echo openruyi | sudo -S dnf install -y ca-certificates-mozilla 2>/dev/null
            echo "installed=1" > "$PKG_FLAG"
            rlLogInfo "已安装 ca-certificates-mozilla 软件包（首次）"
        else
            echo "installed=0" > "$PKG_FLAG"
            rlLogInfo "ca-certificates-mozilla 软件包已存在"
        fi
        echo "ref=1" >> "$PKG_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
        rlLogInfo "ca-certificates-mozilla 已由其他测试安装，引用计数: $ref"
    fi
    rlCleanupAppend "caCertificatesMozillaCleanup"
}

caCertificatesMozillaCleanup() {
    if [ ! -f "$PKG_FLAG" ]; then
        return 0
    fi
    local ref
    ref=$(grep "^ref=" "$PKG_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        if grep -q "^installed=1" "$PKG_FLAG"; then
            echo openruyi | sudo -S dnf remove -y ca-certificates-mozilla 2>/dev/null || true
            rlLogInfo "已卸载 ca-certificates-mozilla 软件包（最后一个测试）"
        fi
        rm -f "$PKG_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$PKG_FLAG"
        rlLogInfo "ca-certificates-mozilla 保留（还有 $ref 个测试未完成）"
    fi
}
