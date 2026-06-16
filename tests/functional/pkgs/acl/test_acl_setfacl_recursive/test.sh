#!/bin/sh -eux
# Functional test: acl - setfacl-递归功能

. "../setup.sh"

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

. "../teardown.sh"
echo "All acl setfacl-递归功能 tests passed!"
