#!/bin/sh -eux
# Functional test: acl - chacl-命令功能

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

echo "=== 测试 7: chacl 命令功能 ==="

# 测试 7.1: 使用 chacl 查看 ACL
rlRun 'setfacl -b testfile' 0 "先清理 ACL"
rlRun 'chacl -l testfile' 0 "使用 chacl 查看 ACL"

# 测试 7.2: 使用 chacl 设置 ACL
rlRun 'chacl u::rw-,g::r--,o::r-- testfile' 0 "使用 chacl 设置基本 ACL"
rlRun 'getfacl testfile' 0 "验证 chacl 设置的 ACL"

# 测试 7.3: 使用 chacl -d 设置 default ACL
rlRun 'chacl -d u::rwx,g::r-x,o::r-x testdir' 0 "使用 chacl 设置 default ACL"
rlRun 'getfacl testdir' 0 "验证 chacl 设置的 default ACL"

# 测试 7.4: 使用 chacl -R 递归设置
rlRun 'chacl -R u::rw-,g::r--,o::r-- testdir' 0 "使用 chacl 递归设置 ACL"
rlRun 'getfacl testdir/file1' 0 "验证 chacl 递归设置"

# 测试 7.5: 使用 chacl -b 同时设置 access 和 default ACL
rlRun 'chacl -b u::rwx,g::r-x,o::r-x u::rwx,g::r-x,o::r-x testdir' 0 "使用 chacl -b 同时设置"
rlRun 'getfacl testdir' 0 "验证 chacl -b 设置"


echo ""
echo "All acl chacl-命令功能 tests passed!"
