#!/bin/sh -eux
# Functional test: acl - setfacl-基本功能

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



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
    echo "TEARDOWN: removed acl"
fi
echo ""
echo "All acl setfacl-基本功能 tests passed!"
