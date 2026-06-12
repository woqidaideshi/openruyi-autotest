#!/bin/sh -eux
# Functional test: acl - getfacl-基本功能

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

echo "=== 测试 1: getfacl 基本功能 ==="

# 测试 1.1: 查看文件默认 ACL
rlRun 'getfacl testfile' 0 "查看文件默认 ACL"

# 测试 1.2: 查看目录默认 ACL  
rlRun 'getfacl testdir' 0 "查看目录默认 ACL"

# 测试 1.3: 使用 -a 参数只显示 access ACL
rlRun 'getfacl -a testfile' 0 "使用 -a 参数查看 access ACL"

# 测试 1.4: 使用 -d 参数只显示 default ACL
rlRun 'getfacl -d testfile' 0 "使用 -d 参数查看 default ACL"

# 测试 1.5: 使用 -c 参数不显示注释头
rlRun 'getfacl -c testfile' 0 "使用 -c 参数不显示注释头"

# 测试 1.6: 使用 -n 参数显示数字用户/组 ID
rlRun 'getfacl -n testfile' 0 "使用 -n 参数显示数字 ID"

# 测试 1.7: 使用 -t 参数使用表格输出格式
rlRun 'getfacl -t testfile' 0 "使用 -t 参数表格输出"


echo ""
echo "All acl getfacl-基本功能 tests passed!"
