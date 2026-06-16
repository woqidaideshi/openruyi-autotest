#!/bin/sh -eux
# Functional test: acl - setfacl-基本功能

. "../setup.sh"

echo "=== 测试 2: setfacl 基本功能 ==="

# 测试 2.1: 设置用户 ACL 权限
rlRun 'setfacl -m u:root:rwx testfile' 0 "设置用户 root 的 rwx 权限"
rlRun 'getfacl testfile' 0 "验证 ACL 设置"

# 测试 2.2: 设置组 ACL 权限
rlRun 'setfacl -m g:root:r-x testfile' 0 "设置组 root 的 r-x 权限"
rlRun 'getfacl testfile' 0 "验证 ACL 设置"

# 测试 2.3: 设置 other 权限
rlRun 'setfacl -m o::r-- testfile' 0 "设置 other 的只读权限"
rlRun 'getfacl testfile' 0 "验证 ACL 设置"

# 测试 2.4: 设置 mask 权限
rlRun 'setfacl -m m::rwx testfile' 0 "设置 mask 为 rwx"
rlRun 'getfacl testfile' 0 "验证 mask 设置"

# 测试 2.5: 使用 -n 参数不重新计算 mask
rlRun 'setfacl -n -m u:root:r-- testfile' 0 "使用 -n 参数不重新计算 mask"
rlRun 'getfacl testfile' 0 "验证 ACL 设置"

. "../teardown.sh"
echo "All acl setfacl-基本功能 tests passed!"
