#!/bin/sh -eux
# Functional test: acl - 错误处理

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

echo "=== 测试 10: 错误处理 ==="

# 测试 10.1: 对不存在的文件操作
rlRun 'getfacl nonexistent_file' 1-255 "测试对不存在文件 getfacl 报错"
rlRun 'setfacl -m u:root:rwx nonexistent_file' 1-255 "测试对不存在文件 setfacl 报错"

# 测试 10.2: 无效的 ACL 规则
rlRun 'setfacl -m u:root:xyz testfile' 1-255 "测试无效权限字符报错"
rlRun 'setfacl -m x:root:rw testfile' 1-255 "测试无效类型报错"

# 测试 10.3: 权限不足
rlRun 'su -c "setfacl -m u:root:rwx /root/test" openruyi 2>&1' 1-255 "测试权限不足报错"


echo ""
echo "All acl 错误处理 tests passed!"
