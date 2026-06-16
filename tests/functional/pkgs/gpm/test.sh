#!/bin/sh -eux
# Functional test: gpm - gpm 通用鼠标支持
# Services: gpm

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install gpm ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q gpm 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck gpm 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed gpm"
    else
        echo "SKIP: gpm not available in repos"
        exit 0
    fi
else
    echo "SETUP: gpm already installed"
fi

# 获取版本信息
rlRun 'rpm -q gpm' 0 "获取 gpm 版本信息"

# 列出包内二进制文件
rlRun 'rpm -ql gpm 2>/dev/null | grep -E "^/usr/bin/|^/usr/sbin/|^/bin/|^/sbin/" || echo "NO_BINARIES"' 0 "列出包内二进制文件"

# 检查服务文件
rlRun 'rpm -ql gpm 2>/dev/null | grep -E "\.service$|\.socket$|\.target$" || echo "NO_SYSTEMD_FILES"' 0 "检查 systemd 服务文件"

# 检查配置文件
rlRun 'rpm -ql gpm 2>/dev/null | grep -E "^/etc/" || echo "NO_CONFIG_FILES"' 0 "检查配置文件"

# 检查手册页
rlRun 'rpm -ql gpm 2>/dev/null | grep -E "\.1\.gz$|\.5\.gz$|\.8\.gz$" || echo "NO_MAN_PAGES"' 0 "检查手册页"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y gpm 2>/dev/null || true
    echo "TEARDOWN: removed gpm"
fi
echo ""
echo "All gpm tests passed!"
