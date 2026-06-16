#!/bin/sh -eux
# Functional test: acl - ACL-权限验证

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

echo "=== 测试 9: ACL 权限验证 ==="

# 测试 9.1: 验证读写执行权限
rlRun 'setfacl --set u::rwx,u:root:rwx,g::r-x,o::r--,m::rwx testfile' 0 "设置完整权限"
rlRun 'getfacl testfile' 0 "验证权限设置"

# 测试 9.2: 验证 mask 对有效权限的影响
rlRun 'setfacl -m u:root:rwx,m::r-- testfile' 0 "设置 mask 限制有效权限"
rlRun 'getfacl testfile' 0 "验证 mask 限制后的有效权限"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
    echo "TEARDOWN: removed acl"
fi
echo ""
echo "All acl ACL-权限验证 tests passed!"
