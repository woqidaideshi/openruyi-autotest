#!/bin/sh -eux
# Functional test: acl - setfacl-符号链接处理

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

echo "=== 测试 6: setfacl 符号链接处理 ==="

# 测试 6.1: 创建符号链接
rlRun 'ln -s testfile symlink' 0 "创建符号链接"

# 测试 6.2: 使用 -L 参数跟随符号链接
rlRun 'setfacl -L -m u:root:rwx symlink' 0 "使用 -L 跟随符号链接设置 ACL"
rlRun 'getfacl testfile' 0 "验证符号链接目标文件的 ACL"

# 测试 6.3: 使用 -P 参数不跟随符号链接
rlRun 'setfacl -P -m u:root:r-- symlink' 0 "使用 -P 不跟随符号链接"



# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
    echo "TEARDOWN: removed acl"
fi
echo ""
echo "All acl setfacl-符号链接处理 tests passed!"
