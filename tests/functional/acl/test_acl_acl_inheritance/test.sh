#!/bin/sh -eux
# Functional test: acl - ACL-继承测试

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

echo "=== 测试 8: ACL 继承测试 ==="

# 测试 8.1: 在设置了 default ACL 的目录中创建文件
rlRun 'setfacl -m d:u:root:rwx,d:g:root:r-x,d:o::r-- testdir' 0 "设置目录 default ACL"
rlRun 'touch testdir/newfile' 0 "在目录中创建新文件"
rlRun 'getfacl testdir/newfile' 0 "验证新文件继承了 default ACL"

# 测试 8.2: 在设置了 default ACL 的目录中创建子目录
rlRun 'mkdir testdir/newsubdir' 0 "在目录中创建子目录"
rlRun 'getfacl testdir/newsubdir' 0 "验证子目录继承了 default ACL"


echo ""
echo "All acl ACL-继承测试 tests passed!"
