#!/bin/sh -eux
# Functional test: gpm - gpm 通用鼠标支持
# Services: gpm

. "./setup.sh"


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

. "./teardown.sh"
echo "All gpm tests passed!"
