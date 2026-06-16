#!/bin/sh -eux
# Functional test: acl - ACL-权限验证

. "../setup.sh"

echo "=== 测试 9: ACL 权限验证 ==="

# 测试 9.1: 验证读写执行权限
rlRun 'setfacl --set u::rwx,u:root:rwx,g::r-x,o::r--,m::rwx testfile' 0 "设置完整权限"
rlRun 'getfacl testfile' 0 "验证权限设置"

# 测试 9.2: 验证 mask 对有效权限的影响
rlRun 'setfacl -m u:root:rwx,m::r-- testfile' 0 "设置 mask 限制有效权限"
rlRun 'getfacl testfile' 0 "验证 mask 限制后的有效权限"

. "../teardown.sh"
echo "All acl ACL-权限验证 tests passed!"
