#!/bin/bash
# Functional test: acl - error handling
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch testfile" 0 "创建测试文件"
    rlPhaseEnd

    rlPhaseStartTest "错误处理"
        rlRun "getfacl nonexistent_file" 1-255 "测试对不存在文件 getfacl 报错"
        rlRun "setfacl -m u:root:rwx nonexistent_file" 1-255 "测试对不存在文件 setfacl 报错"

        rlRun "setfacl -m u:root:xyz testfile" 1-255 "测试无效权限字符报错"
        rlRun "setfacl -m x:root:rw testfile" 1-255 "测试无效 ACL 类型报错"

        rlRun "su -c 'setfacl -m u:root:rwx /root/test' openruyi 2>&1" 1-255 "测试权限不足报错"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # acl 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
