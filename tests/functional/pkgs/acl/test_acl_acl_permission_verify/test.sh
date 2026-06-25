#!/bin/bash
# Functional test: acl - ACL permission verify
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

    rlPhaseStartTest "ACL 权限验证"
        rlRun "setfacl --set u::rwx,u:root:rwx,g::r-x,o::r--,m::rwx testfile" 0 "设置完整权限"
        output=$(getfacl testfile 2>&1)
        rlAssertGrep "user::rwx" "$output" "确认 user::rwx 已设置"
        rlAssertGrep "user:root:rwx" "$output" "确认 user:root:rwx 已设置"
        rlAssertGrep "group::r-x" "$output" "确认 group::r-x 已设置"
        rlAssertGrep "mask::rwx" "$output" "确认 mask::rwx 已设置"

        rlRun "setfacl -m u:root:rwx,m::r-- testfile" 0 "设置 mask 限制有效权限"
        output=$(getfacl testfile 2>&1)
        rlAssertGrep "mask::r--" "$output" "确认 mask::r-- 限制已设置"
        rlAssertGrep "user:root:rwx" "$output" "确认 user:root 权限受 mask 限制"
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
