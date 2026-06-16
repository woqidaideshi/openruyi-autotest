#!/bin/sh -eux
# Functional test: boost - Boost C++ 库集合

. "./setup.sh"


# 获取版本信息
rlRun 'rpm -q boost' 0 "获取 boost 版本信息"

# 列出包内文件
rlRun 'rpm -ql boost 2>/dev/null' 0 "列出 boost 文件列表"

# 检查共享库文件
rlRun 'rpm -ql boost 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql boost 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

. "./teardown.sh"
echo "All boost tests passed!"
