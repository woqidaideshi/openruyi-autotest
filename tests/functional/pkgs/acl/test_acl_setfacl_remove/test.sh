#!/bin/bash
# Functional test: acl - setfacl remove
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
        # 预设 ACL 供删除测试使用
        rlRun "setfacl -m u:root:rwx,g:root:r-x testfile" 0 "预设 ACL 供删除测试"
    rlPhaseEnd

    rlPhaseStartTest "setfacl 删除功能"
        rlRun "setfacl -x u:root testfile" 0 "删除用户 root 的 ACL 条目"
        output=$(getfacl testfile 2>&1)
        rlAssertNotGrep "user:root:" "$output" "确认用户 root 条目已删除"

        rlRun "setfacl -x g:root testfile" 0 "删除组 root 的 ACL 条目"
        output=$(getfacl testfile 2>&1)
        rlAssertNotGrep "group:root:" "$output" "确认组 root 条目已删除"

        rlRun "setfacl -b testfile" 0 "删除所有扩展 ACL"
        output=$(getfacl testfile 2>&1)
        rlAssertNotGrep "user:root:" "$output" "确认 -b 后无扩展 ACL"

        rlRun "setfacl -k testdir" 0 "删除目录的 default ACL"
        output=$(getfacl testdir 2>&1)
        rlAssertNotGrep "default:" "$output" "确认 -k 后无 default ACL"

        rlRun "echo 'u:root' > remove_rules.txt" 0 "创建删除规则文件"
        rlRun "setfacl -m u:root:rwx testfile" 0 "先添加用户 ACL"
        rlRun "setfacl -X remove_rules.txt testfile" 0 "从文件读取并删除 ACL"
        output=$(getfacl testfile 2>&1)
        rlAssertNotGrep "user:root:" "$output" "确认从文件删除成功"
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
