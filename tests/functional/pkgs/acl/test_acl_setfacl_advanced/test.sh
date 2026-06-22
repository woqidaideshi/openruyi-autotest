#!/bin/bash
# Functional test: acl - setfacl advanced
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
        rlRun "mkdir testdir" 0 "创建测试目录"
    rlPhaseEnd

    rlPhaseStartTest "setfacl 高级功能"
        rlRun "setfacl -m d:u:root:rwx testdir" 0 "为目录设置 default user ACL"
        rlRun "getfacl testdir" 0 "验证 default ACL 设置"
        rlAssertGrep "default:user:root:rwx" "$(getfacl testdir 2>&1)" "确认 default:user:root:rwx 已设置"

        rlRun "setfacl -m d:g:root:r-x testdir" 0 "为目录设置 default group ACL"
        rlRun "getfacl testdir" 0 "验证 default group ACL"

        rlRun "setfacl -m d:m::rwx testdir" 0 "为目录设置 default mask"
        rlRun "getfacl testdir" 0 "验证 default mask"

        rlRun "setfacl -m d:o::r-- testdir" 0 "为目录设置 default other"
        rlRun "getfacl testdir" 0 "验证 default other"

        rlRun "setfacl --set u::rw-,u:root:rwx,g::r--,o::r--,m::rwx testfile" 0 "使用 --set 替换整个 ACL"
        rlRun "getfacl testfile" 0 "验证 ACL 替换"
        rlAssertGrep "user:root:rwx" "$(getfacl testfile 2>&1)" "确认 --set 已替换 ACL"

        rlRun "echo 'u:root:rw-' > acl_rules.txt" 0 "创建 ACL 规则文件"
        rlRun "setfacl -M acl_rules.txt testfile" 0 "从文件读取并应用 ACL"
        rlRun "getfacl testfile" 0 "验证从文件应用的 ACL"
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
