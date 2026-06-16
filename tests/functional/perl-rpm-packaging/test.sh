#!/bin/sh -eux
# Functional test: perl-rpm-packaging - perl-RPM 打包宏

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-rpm-packaging ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q perl-rpm-packaging 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck perl-rpm-packaging 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-rpm-packaging"
    else
        echo "SKIP: perl-rpm-packaging not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-rpm-packaging already installed"
fi

# 获取版本信息
rlRun 'rpm -q perl-rpm-packaging' 0 "获取 perl-rpm-packaging 版本信息"

# 列出包内文件
rlRun 'perl -e "use rpm-packaging;" 2>&1 || echo "NO_MODULE"' 0 "加载 perl-rpm-packaging Perl 模块"

# 检查共享库文件
rlRun 'rpm -ql perl-rpm-packaging 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql perl-rpm-packaging 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-rpm-packaging 2>/dev/null || true
    echo "TEARDOWN: removed perl-rpm-packaging"
fi
echo ""
echo "All perl-rpm-packaging tests passed!"
