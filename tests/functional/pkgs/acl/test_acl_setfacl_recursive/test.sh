#!/bin/bash
# Functional test: acl - setfacl recursive
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        aclSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "mkdir -p testdir/subdir1/subdir2" 0 "创建多层子目录"
        rlRun "touch testdir/file1 testdir/subdir1/file2" 0 "创建测试文件"
    rlPhaseEnd

    rlPhaseStartTest "setfacl 递归功能"
        rlRun "setfacl -R -m u:root:rw- testdir" 0 "递归设置 user ACL"
        output1=$(getfacl testdir/file1 2>&1)
        output2=$(getfacl testdir/subdir1/file2 2>&1)
        rlAssertGrep "user:root:rw-" "$output1" "验证 file1 上递归设置的 ACL"
        rlAssertGrep "user:root:rw-" "$output2" "验证 subdir1/file2 上递归设置的 ACL"

        rlRun "setfacl -R -b testdir" 0 "递归删除所有扩展 ACL"
        output1=$(getfacl testdir/file1 2>&1)
        output2=$(getfacl testdir/subdir1/file2 2>&1)
        rlAssertNotGrep "user:root:" "$output1" "确认 file1 上递归删除成功"
        rlAssertNotGrep "user:root:" "$output2" "确认 subdir1/file2 上递归删除成功"
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
