#!/bin/bash
# Functional test: acl - setfacl basic
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

    rlPhaseStartTest "setfacl 基本功能"
        rlRun "setfacl -m u:root:rwx testfile" 0 "设置用户 root 的 rwx 权限"
        rlRun "getfacl testfile" 0 "验证 ACL 设置"
        rlAssertGrep "user:root:rwx" "$(getfacl testfile 2>&1)" "确认 user:root:rwx 已设置"

        rlRun "setfacl -m g:root:r-x testfile" 0 "设置组 root 的 r-x 权限"
        rlRun "getfacl testfile" 0 "验证 ACL 设置"
        rlAssertGrep "group:root:r-x" "$(getfacl testfile 2>&1)" "确认 group:root:r-x 已设置"

        rlRun "setfacl -m o::r-- testfile" 0 "设置 other 的只读权限"
        rlRun "getfacl testfile" 0 "验证 ACL 设置"
        rlAssertGrep "other::r--" "$(getfacl testfile 2>&1)" "确认 other::r-- 已设置"

        rlRun "setfacl -m m::rwx testfile" 0 "设置 mask 为 rwx"
        rlRun "getfacl testfile" 0 "验证 mask 设置"
        rlAssertGrep "mask::rwx" "$(getfacl testfile 2>&1)" "确认 mask::rwx 已设置"

        rlRun "setfacl -n -m u:root:r-- testfile" 0 "使用 -n 参数不重新计算 mask"
        rlRun "getfacl testfile" 0 "验证 ACL 设置"
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
