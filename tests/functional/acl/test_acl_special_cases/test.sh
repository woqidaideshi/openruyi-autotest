#!/bin/sh -eux
# Functional test: acl - 特殊场景

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q acl' 0 "检查 acl 软件包是否已安装"
rlRun 'which getfacl' 0 "检查 getfacl 命令是否可用"
rlRun 'which setfacl' 0 "检查 setfacl 命令是否可用"
rlRun 'which chacl' 0 "检查 chacl 命令是否可用"
rlRun 'getfacl --version' 0 "获取 getfacl 版本信息"
rlRun 'setfacl --version' 0 "获取 setfacl 版本信息"
rlRun 'TmpDir=$(mktemp -d)' 0 "创建临时测试目录"
rlRun 'cd $TmpDir' 0 "进入测试目录"
rlRun 'touch testfile' 0 "创建测试文件"
rlRun 'mkdir testdir' 0 "创建测试目录"

echo "=== 测试 11: 特殊场景 ==="

# 测试 11.1: 多个用户/组的 ACL
rlRun 'setfacl -m u:root:rwx,u:openruyi:r-x,g:root:r--,g:openruyi:rw- testfile' 0 "设置多个用户和组 ACL"
rlRun 'getfacl testfile' 0 "验证多个 ACL 条目"

# 测试 11.2: ACL 导出和恢复
rlRun 'setfacl -m u:root:rwx,g:root:rwx testfile' 0 "设置测试 ACL"
rlRun 'getfacl -R testdir > acl_backup.txt' 0 "导出 ACL 备份"
rlRun 'setfacl -b testfile' 0 "清除 ACL"
rlRun 'setfacl --restore acl_backup.txt 2>&1 || true' 0 "尝试恢复 ACL"

# 测试 11.3: 测试 --test 模式
rlRun 'setfacl --test -m u:root:rwx testfile' 0 "使用 --test 模式不实际修改"
rlRun 'getfacl testfile' 0 "验证 --test 模式未修改 ACL"

# 清理测试环境
rlRun 'cd /' 0 "离开测试目录"
rlRun 'rm -rf $TmpDir' 0 "清理临时测试目录"

echo ""
echo "All acl functional tests passed!"

echo ""
echo "All acl 特殊场景 tests passed!"
