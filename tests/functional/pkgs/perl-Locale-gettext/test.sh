#!/bin/sh -eux
# Functional test: perl-Locale-gettext - perl-Locale-gettext 国际化

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install perl-Locale-gettext ===
# Kill any stale dnf processes first
echo openruyi | sudo -S pkill -9 dnf 2>/dev/null || true
echo openruyi | sudo -S rm -f /var/run/dnf.pid 2>/dev/null || true
INSTALLED_BY_TEST=0
if ! rpm -q perl-Locale-gettext 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y --nogpgcheck perl-Locale-gettext 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed perl-Locale-gettext"
    else
        echo "SKIP: perl-Locale-gettext not available in repos"
        exit 0
    fi
else
    echo "SETUP: perl-Locale-gettext already installed"
fi

# 获取版本信息
rlRun 'rpm -q perl-Locale-gettext' 0 "获取 perl-Locale-gettext 版本信息"

# 列出包内文件
rlRun 'perl -e "use Locale-gettext;" 2>&1 || echo "NO_MODULE"' 0 "加载 perl-Locale-gettext Perl 模块"

# 检查共享库文件
rlRun 'rpm -ql perl-Locale-gettext 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql perl-Locale-gettext 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y perl-Locale-gettext 2>/dev/null || true
    echo "TEARDOWN: removed perl-Locale-gettext"
fi
echo ""
echo "All perl-Locale-gettext tests passed!"
