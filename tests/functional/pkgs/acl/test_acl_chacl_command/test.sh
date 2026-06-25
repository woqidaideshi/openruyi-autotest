#!/bin/bash
# Functional test: acl - chacl command
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
        rlRun "touch testdir/file1" 0 "创建测试子文件"
    rlPhaseEnd

    rlPhaseStartTest "chacl 命令功能"
        rlRun "setfacl -b testfile" 0 "先清理 ACL"
        rlRun "chacl -l testfile" 0 "使用 chacl 查看 ACL"

        rlRun "chacl u::rw-,g::r--,o::r-- testfile" 0 "使用 chacl 设置基本 ACL"
        output=$(getfacl testfile 2>&1)
        rlAssertGrep "user::rw-" "$output" "确认 chacl 设置了 user ACL"

        rlRun "chacl -d u::rwx,g::r-x,o::r-x testdir" 0 "使用 chacl 设置 default ACL"
        output=$(getfacl testdir 2>&1)
        rlAssertGrep "default:user::rwx" "$output" "确认 chacl -d 设置了 default ACL"

        rlRun "chacl -R u::rw-,g::r--,o::r-- testdir" 0 "使用 chacl 递归设置 ACL"
        output=$(getfacl testdir/file1 2>&1)
        rlAssertGrep "user::rw-" "$output" "确认 chacl -R 递归设置成功"

        rlRun "chacl -b u::rwx,g::r-x,o::r-x u::rwx,g::r-x,o::r-x testdir" 0 "使用 chacl -b 同时设置"
        output=$(getfacl testdir 2>&1)
        rlAssertGrep "default:user::rwx" "$output" "确认 chacl -b 同时设置 access+default"
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
