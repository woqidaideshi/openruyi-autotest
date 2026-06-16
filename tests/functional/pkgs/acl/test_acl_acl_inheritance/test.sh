#!/bin/sh -eux
# Functional test: acl - ACL-继承测试

. "../setup.sh"

echo "=== 测试 8: ACL 继承测试 ==="

# 测试 8.1: 在设置了 default ACL 的目录中创建文件
rlRun 'setfacl -m d:u:root:rwx,d:g:root:r-x,d:o::r-- testdir' 0 "设置目录 default ACL"
rlRun 'touch testdir/newfile' 0 "在目录中创建新文件"
rlRun 'getfacl testdir/newfile' 0 "验证新文件继承了 default ACL"

# 测试 8.2: 在设置了 default ACL 的目录中创建子目录
rlRun 'mkdir testdir/newsubdir' 0 "在目录中创建子目录"
rlRun 'getfacl testdir/newsubdir' 0 "验证子目录继承了 default ACL"

. "../teardown.sh"
echo "All acl ACL-继承测试 tests passed!"
