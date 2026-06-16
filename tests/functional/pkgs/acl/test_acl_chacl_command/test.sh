#!/bin/sh -eux
# Functional test: acl - chacl-命令功能

. "../setup.sh"

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

. "../teardown.sh"
echo "All acl chacl-命令功能 tests passed!"
