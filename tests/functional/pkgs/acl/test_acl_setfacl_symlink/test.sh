#!/bin/bash
# Functional test: acl - setfacl symlink
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
        rlRun "ln -s testfile symlink" 0 "创建符号链接"
    rlPhaseEnd

    rlPhaseStartTest "setfacl 符号链接处理"
        rlRun "setfacl -L -m u:root:rwx symlink" 0 "使用 -L 跟随符号链接设置 ACL"
        output=$(getfacl testfile 2>&1)
        rlAssertGrep "user:root:rwx" "$output" "确认 -L 跟随符号链接设置成功"

        rlRun "setfacl -b testfile" 0 "清理 ACL"
        rlRun "setfacl -P -m u:root:r-- symlink" 0 "使用 -P 不跟随符号链接"
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
