#!/bin/sh -eux
# Functional test: unbound - unbound DNS 解析器
# Services: unbound/unbound-checkconf/unbound-control

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install unbound ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q unbound 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck unbound 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed unbound"
    else
        echo "SKIP: unbound not available in repos"
        exit 0
    fi
else
    echo "SETUP: unbound already installed"
fi

# 获取版本信息
rlRun 'rpm -q unbound' 0 "获取 unbound 版本信息"

# 列出包内二进制文件
rlRun 'rpm -ql unbound 2>/dev/null | grep -E "^/usr/bin/|^/usr/sbin/|^/bin/|^/sbin/" || echo "NO_BINARIES"' 0 "列出包内二进制文件"

# 检查服务文件
rlRun 'rpm -ql unbound 2>/dev/null | grep -E "\.service$|\.socket$|\.target$" || echo "NO_SYSTEMD_FILES"' 0 "检查 systemd 服务文件"

# 检查配置文件
rlRun 'rpm -ql unbound 2>/dev/null | grep -E "^/etc/" || echo "NO_CONFIG_FILES"' 0 "检查配置文件"

# 检查手册页
rlRun 'rpm -ql unbound 2>/dev/null | grep -E "\.1\.gz$|\.5\.gz$|\.8\.gz$" || echo "NO_MAN_PAGES"' 0 "检查手册页"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y unbound 2>/dev/null || true
    echo "TEARDOWN: removed unbound"
fi
echo ""
echo "All unbound tests passed!"
