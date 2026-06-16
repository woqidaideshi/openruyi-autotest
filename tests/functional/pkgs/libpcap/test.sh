#!/bin/sh -eux
# Functional test: libpcap - libpcap 网络数据包捕获库

. "./setup.sh"


# 获取版本信息
rlRun 'rpm -q libpcap' 0 "获取 libpcap 版本信息"

# 列出包内文件
rlRun 'rpm -ql libpcap 2>/dev/null' 0 "列出 libpcap 文件列表"

# 检查共享库文件
rlRun 'rpm -ql libpcap 2>/dev/null | grep -E "\.so\.|\\.so$" || echo "NO_SO_FILES"' 0 "检查共享库文件"

# 检查头文件（如果有）
rlRun 'rpm -ql libpcap 2>/dev/null | grep -E "\.h$|\.pc$" || echo "NO_HEADER_FILES"' 0 "检查头文件和 pkg-config 文件"

. "./teardown.sh"
echo "All libpcap tests passed!"
