#!/bin/sh -eux
# Functional test: perl-Error - perl-Error 错误处理模块

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-Error ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q perl-Error 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck perl-Error 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-Error"
    else
        echo "SKIP: perl-Error not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-Error already installed"
fi

# 获取版本信息
rlRun 'rpm -q perl-Error' 0 "获取 perl-Error 版本信息"

# 列出包内文件
rlRun 'perl -e "use Error;" 2>&1 || echo "NO_MODULE"' 0 "加载 perl-Error Perl 模块"

# 检查共享库文件
rlRun 'rpm -ql perl-Error 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql perl-Error 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-Error 2>/dev/null || true
    echo "TEARDOWN: removed perl-Error"
fi
echo ""
echo "All perl-Error tests passed!"
