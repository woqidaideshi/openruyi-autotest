#!/bin/bash
# Functional test: acl - ACL inheritance
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "mkdir testdir" 0 "创建测试目录"
        rlRun "setfacl -m d:u:root:rwx,d:g:root:r-x,d:o::r-- testdir" 0 "设置目录 default ACL"
    rlPhaseEnd

    rlPhaseStartTest "ACL 继承测试"
        rlRun "touch testdir/newfile" 0 "在目录中创建新文件"
        output=$(getfacl testdir/newfile 2>&1)
        rlAssertGrep "user:root:rwx" "$output" "新文件继承了 user default ACL"
        rlAssertGrep "group:root:r-x" "$output" "新文件继承了 group default ACL"

        rlRun "mkdir testdir/newsubdir" 0 "在目录中创建子目录"
        output=$(getfacl testdir/newsubdir 2>&1)
        rlAssertGrep "default:user:root:rwx" "$output" "子目录继承了 default user ACL"
        rlAssertGrep "default:group:root:r-x" "$output" "子目录继承了 default group ACL"
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
