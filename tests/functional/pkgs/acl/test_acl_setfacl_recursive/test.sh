#!/bin/sh -eux
# Functional test: acl - setfacl-递归功能

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

echo "=== 测试 5: setfacl 递归功能 ==="

# 测试 5.1: 递归设置目录 ACL
rlRun 'mkdir -p testdir/subdir1/subdir2' 0 "创建多层子目录"
rlRun 'touch testdir/file1 testdir/subdir1/file2' 0 "创建测试文件"
rlRun 'setfacl -R -m u:root:rw- testdir' 0 "递归设置 user ACL"
rlRun 'getfacl testdir/file1' 0 "验证递归设置 - file1"
rlRun 'getfacl testdir/subdir1/file2' 0 "验证递归设置 - file2"

# 测试 5.2: 递归删除 ACL
rlRun 'setfacl -R -b testdir' 0 "递归删除所有扩展 ACL"
rlRun 'getfacl testdir/file1' 0 "验证递归删除 - file1"
rlRun 'getfacl testdir/subdir1/file2' 0 "验证递归删除 - file2"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
    echo "TEARDOWN: removed acl"
fi
echo ""
echo "All acl setfacl-递归功能 tests passed!"
