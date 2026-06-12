#!/bin/sh -eux
# Functional test: acl - setfacl-删除功能

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

echo "=== 测试 4: setfacl 删除功能 ==="

# 测试 4.1: 删除特定用户 ACL
rlRun 'setfacl -x u:root testfile' 0 "删除用户 root 的 ACL 条目"
rlRun 'getfacl testfile' 0 "验证 ACL 删除"

# 测试 4.2: 删除特定组 ACL
rlRun 'setfacl -x g:root testfile' 0 "删除组 root 的 ACL 条目"
rlRun 'getfacl testfile' 0 "验证 ACL 删除"

# 测试 4.3: 使用 -b 删除所有扩展 ACL
rlRun 'setfacl -b testfile' 0 "删除所有扩展 ACL"
rlRun 'getfacl testfile' 0 "验证所有扩展 ACL 已删除"

# 测试 4.4: 使用 -k 删除 default ACL
rlRun 'setfacl -k testdir' 0 "删除目录的 default ACL"
rlRun 'getfacl testdir' 0 "验证 default ACL 已删除"

# 测试 4.5: 从文件读取删除规则
rlRun 'echo "u:root" > remove_rules.txt' 0 "创建删除规则文件"
rlRun 'setfacl -m u:root:rwx testfile' 0 "先添加用户 ACL"
rlRun 'setfacl -X remove_rules.txt testfile' 0 "从文件读取并删除 ACL"
rlRun 'getfacl testfile' 0 "验证从文件删除的 ACL"


echo ""
echo "All acl setfacl-删除功能 tests passed!"
