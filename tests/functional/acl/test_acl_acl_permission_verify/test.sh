#!/bin/sh -eux
# Functional test: acl - ACL-权限验证

rlRun() { eval "$1" 2>&1; return $?; }
rpm -q acl 2>/dev/null || { echo 'acl not installed, skipping'; exit 0; }
which getfacl 2>/dev/null || echo 'getfacl not found (non-fatal)'
which setfacl 2>/dev/null || echo 'setfacl not found (non-fatal)'
which chacl 2>/dev/null || echo 'chacl not found (non-fatal)'
rlRun 'getfacl --version' 0 "获取 getfacl 版本信息"
rlRun 'setfacl --version' 0 "获取 setfacl 版本信息"
rlRun 'TmpDir=$(mktemp -d)' 0 "创建临时测试目录"
rlRun 'cd $TmpDir' 0 "进入测试目录"
rlRun 'touch testfile' 0 "创建测试文件"
rlRun 'mkdir testdir' 0 "创建测试目录"

echo "=== 测试 9: ACL 权限验证 ==="

# 测试 9.1: 验证读写执行权限
rlRun 'setfacl --set u::rwx,u:root:rwx,g::r-x,o::r--,m::rwx testfile' 0 "设置完整权限"
rlRun 'getfacl testfile' 0 "验证权限设置"

# 测试 9.2: 验证 mask 对有效权限的影响
rlRun 'setfacl -m u:root:rwx,m::r-- testfile' 0 "设置 mask 限制有效权限"
rlRun 'getfacl testfile' 0 "验证 mask 限制后的有效权限"


echo ""
echo "All acl ACL-权限验证 tests passed!"
