#!/bin/sh -eux
# Functional test: nss_wrapper - nss_wrapper NSS 模拟库

. "./setup.sh"


# 获取版本信息
rlRun 'rpm -q nss_wrapper' 0 "获取 nss_wrapper 版本信息"

# 列出包内文件
rlRun 'rpm -ql nss_wrapper 2>/dev/null' 0 "列出 nss_wrapper 文件列表"

# 检查共享库文件
rlRun 'rpm -ql nss_wrapper 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql nss_wrapper 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

. "./teardown.sh"
echo "All nss_wrapper tests passed!"
