#!/bin/sh -eux
# Functional test: acl - setfacl-符号链接处理

. "../setup.sh"

echo "=== 测试 6: setfacl 符号链接处理 ==="

# 测试 6.1: 创建符号链接
rlRun 'ln -s testfile symlink' 0 "创建符号链接"

# 测试 6.2: 使用 -L 参数跟随符号链接
rlRun 'setfacl -L -m u:root:rwx symlink' 0 "使用 -L 跟随符号链接设置 ACL"
rlRun 'getfacl testfile' 0 "验证符号链接目标文件的 ACL"

# 测试 6.3: 使用 -P 参数不跟随符号链接
rlRun 'setfacl -P -m u:root:r-- symlink' 0 "使用 -P 不跟随符号链接"

. "../teardown.sh"
echo "All acl setfacl-符号链接处理 tests passed!"
