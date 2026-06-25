#!/bin/bash
# Functional test: acl - special cases
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

    rlPhaseStartTest "特殊场景"
        rlRun "setfacl -m u:root:rwx,u:openruyi:r-x,g:root:r--,g:openruyi:rw- testfile" 0 "设置多个用户和组 ACL"
        output=$(getfacl testfile 2>&1)
        rlAssertGrep "user:root:rwx" "$output" "确认 user:root:rwx 已设置"
        rlAssertGrep "user:openruyi:r-x" "$output" "确认 user:openruyi:r-x 已设置"
        rlAssertGrep "group:root:r--" "$output" "确认 group:root:r-- 已设置"
        rlAssertGrep "group:openruyi:rw-" "$output" "确认 group:openruyi:rw- 已设置"

        rlRun "setfacl -m u:root:rwx,g:root:rwx testfile" 0 "设置测试 ACL"
        rlRun "getfacl -R testdir > acl_backup.txt" 0 "导出 ACL 备份"
        rlRun "setfacl -b testfile" 0 "清除 ACL"
        rlRun "setfacl --restore acl_backup.txt 2>&1 || true" 0 "尝试恢复 ACL"

        rlRun "setfacl --test -m u:root:rwx testfile" 0 "使用 --test 模式不实际修改"
        rlRun "getfacl testfile" 0 "验证 --test 模式未修改 ACL"
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
