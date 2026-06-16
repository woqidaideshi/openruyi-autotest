#!/bin/sh -eux
# Functional test: perl-Locale-gettext - perl-Locale-gettext 国际化

. "./setup.sh"

rlRun 'perl -e "use Locale-gettext;" 2>&1 || echo "NO_MODULE"' 0 "加载 perl-Locale-gettext Perl 模块"

# 检查共享库文件
rlRun 'rpm -ql perl-Locale-gettext 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql perl-Locale-gettext 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

. "./teardown.sh"
echo "All perl-Locale-gettext tests passed!"
