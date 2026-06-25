#!/bin/bash
# Functional test: acl - getfacl basic
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

    rlPhaseStartTest "getfacl 基本功能"
        # 测试 1.1: 查看文件默认 ACL
        rlRun "getfacl testfile" 0 "查看文件默认 ACL"

        # 测试 1.2: 查看目录默认 ACL
        rlRun "getfacl testdir" 0 "查看目录默认 ACL"

        # 测试 1.3: 使用 -a 参数只显示 access ACL
        rlRun "getfacl -a testfile" 0 "使用 -a 参数查看 access ACL"
        rlAssertGrep "user::" "$(getfacl -a testfile 2>&1)" "-a 输出包含 access ACL 条目"

        # 测试 1.4: 使用 -d 参数只显示 default ACL
        rlRun "getfacl -d testfile" 0 "使用 -d 参数查看 default ACL"

        # 测试 1.5: 使用 -c 参数不显示注释头
        rlRun "getfacl -c testfile" 0 "使用 -c 参数不显示注释头"
        rlAssertNotGrep "^# file:" "$(getfacl -c testfile 2>&1)" "-c 输出不包含注释头"

        # 测试 1.6: 使用 -n 参数显示数字用户/组 ID
        rlRun "getfacl -n testfile" 0 "使用 -n 参数显示数字 ID"

        # 测试 1.7: 使用 -t 参数使用表格输出格式
        rlRun "getfacl -t testfile" 0 "使用 -t 参数表格输出"
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
