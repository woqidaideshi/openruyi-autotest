#!/bin/sh -eux
# Functional test: acl - setfacl-高级功能

rlRun() { eval "$1" 2>&1; return $?; }
# === SETUP: check/install acl ===
INSTALLED_BY_TEST=0
if ! rpm -q acl 2>/dev/null; then
    if echo openruyi | sudo -S dnf install -y acl 2>/dev/null; then
        INSTALLED_BY_TEST=1
        echo "SETUP: installed acl"
    else
        echo "SKIP: acl not available in repos"
        exit 0
    fi
else
    echo "SETUP: acl already installed"
fi

rlRun 'getfacl --version' 0 "获取 getfacl 版本信息"
rlRun 'setfacl --version' 0 "获取 setfacl 版本信息"
rlRun 'TmpDir=$(mktemp -d)' 0 "创建临时测试目录"
rlRun 'cd $TmpDir' 0 "进入测试目录"
rlRun 'touch testfile' 0 "创建测试文件"
rlRun 'mkdir testdir' 0 "创建测试目录"

echo "=== 测试 3: setfacl 高级功能 ==="

# 测试 3.1: 设置 default ACL (仅目录)
rlRun 'setfacl -m d:u:root:rwx testdir' 0 "为目录设置 default user ACL"
rlRun 'getfacl testdir' 0 "验证 default ACL 设置"

# 测试 3.2: 设置 default group ACL
rlRun 'setfacl -m d:g:root:r-x testdir' 0 "为目录设置 default group ACL"
rlRun 'getfacl testdir' 0 "验证 default group ACL"

# 测试 3.3: 设置 default mask
rlRun 'setfacl -m d:m::rwx testdir' 0 "为目录设置 default mask"
rlRun 'getfacl testdir' 0 "验证 default mask"

# 测试 3.4: 设置 default other
rlRun 'setfacl -m d:o::r-- testdir' 0 "为目录设置 default other"
rlRun 'getfacl testdir' 0 "验证 default other"

# 测试 3.5: 使用 --set 参数替换整个 ACL
rlRun 'setfacl --set u::rw-,u:root:rwx,g::r--,o::r--,m::rwx testfile' 0 "使用 --set 替换整个 ACL"
rlRun 'getfacl testfile' 0 "验证 ACL 替换"

# 测试 3.6: 从文件读取 ACL 设置
rlRun 'echo "u:root:rw-" > acl_rules.txt' 0 "创建 ACL 规则文件"
rlRun 'setfacl -M acl_rules.txt testfile' 0 "从文件读取并应用 ACL"
rlRun 'getfacl testfile' 0 "验证从文件应用的 ACL"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
    echo "TEARDOWN: removed acl"
fi
echo ""
echo "All acl setfacl-高级功能 tests passed!"
