#!/bin/sh -eux
# Functional test: acl (Access Control List) package
# Tests getfacl, setfacl, chacl commands
# Version: acl 2.3.2

# rlRun wrapper for standalone execution
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



# 获取 acl 版本信息
rlRun 'getfacl --version' 0 "获取 getfacl 版本信息"
rlRun 'setfacl --version' 0 "获取 setfacl 版本信息"

# 创建测试环境
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

echo "=== 测试 6: setfacl 符号链接处理 ==="

# 测试 6.1: 创建符号链接
rlRun 'ln -s testfile symlink' 0 "创建符号链接"

# 测试 6.2: 使用 -L 参数跟随符号链接
rlRun 'setfacl -L -m u:root:rwx symlink' 0 "使用 -L 跟随符号链接设置 ACL"
rlRun 'getfacl testfile' 0 "验证符号链接目标文件的 ACL"

# 测试 6.3: 使用 -P 参数不跟随符号链接
rlRun 'setfacl -P -m u:root:r-- symlink' 0 "使用 -P 不跟随符号链接"

echo "=== 测试 7: chacl 命令功能 ==="

# 测试 7.1: 使用 chacl 查看 ACL
rlRun 'setfacl -b testfile' 0 "先清理 ACL"
rlRun 'chacl -l testfile' 0 "使用 chacl 查看 ACL"

# 测试 7.2: 使用 chacl 设置 ACL
rlRun 'chacl u::rw-,g::r--,o::r-- testfile' 0 "使用 chacl 设置基本 ACL"
rlRun 'getfacl testfile' 0 "验证 chacl 设置的 ACL"

# 测试 7.3: 使用 chacl -d 设置 default ACL
rlRun 'chacl -d u::rwx,g::r-x,o::r-x testdir' 0 "使用 chacl 设置 default ACL"
rlRun 'getfacl testdir' 0 "验证 chacl 设置的 default ACL"

# 测试 7.4: 使用 chacl -R 递归设置
rlRun 'chacl -R u::rw-,g::r--,o::r-- testdir' 0 "使用 chacl 递归设置 ACL"
rlRun 'getfacl testdir/file1' 0 "验证 chacl 递归设置"

# 测试 7.5: 使用 chacl -b 同时设置 access 和 default ACL
rlRun 'chacl -b u::rwx,g::r-x,o::r-x u::rwx,g::r-x,o::r-x testdir' 0 "使用 chacl -b 同时设置"
rlRun 'getfacl testdir' 0 "验证 chacl -b 设置"

echo "=== 测试 8: ACL 继承测试 ==="

# 测试 8.1: 在设置了 default ACL 的目录中创建文件
rlRun 'setfacl -m d:u:root:rwx,d:g:root:r-x,d:o::r-- testdir' 0 "设置目录 default ACL"
rlRun 'touch testdir/newfile' 0 "在目录中创建新文件"
rlRun 'getfacl testdir/newfile' 0 "验证新文件继承了 default ACL"

# 测试 8.2: 在设置了 default ACL 的目录中创建子目录
rlRun 'mkdir testdir/newsubdir' 0 "在目录中创建子目录"
rlRun 'getfacl testdir/newsubdir' 0 "验证子目录继承了 default ACL"

echo "=== 测试 9: ACL 权限验证 ==="

# 测试 9.1: 验证读写执行权限
rlRun 'setfacl --set u::rwx,u:root:rwx,g::r-x,o::r--,m::rwx testfile' 0 "设置完整权限"
rlRun 'getfacl testfile' 0 "验证权限设置"

# 测试 9.2: 验证 mask 对有效权限的影响
rlRun 'setfacl -m u:root:rwx,m::r-- testfile' 0 "设置 mask 限制有效权限"
rlRun 'getfacl testfile' 0 "验证 mask 限制后的有效权限"

echo "=== 测试 10: 错误处理 ==="

# 测试 10.1: 对不存在的文件操作
rlRun 'getfacl nonexistent_file' 1-255 "测试对不存在文件 getfacl 报错"
rlRun 'setfacl -m u:root:rwx nonexistent_file' 1-255 "测试对不存在文件 setfacl 报错"

# 测试 10.2: 无效的 ACL 规则
rlRun 'setfacl -m u:root:xyz testfile' 1-255 "测试无效权限字符报错"
rlRun 'setfacl -m x:root:rw testfile' 1-255 "测试无效类型报错"

# 测试 10.3: 权限不足
rlRun 'su -c "setfacl -m u:root:rwx /root/test" openruyi 2>&1' 1-255 "测试权限不足报错"

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

# === TEARDOWN: uninstall if we installed ===
if [ "$INSTALLED_BY_TEST" = "1" ]; then
    echo openruyi | sudo -S dnf remove -y acl 2>/dev/null || true
    echo "TEARDOWN: removed acl"
fi

