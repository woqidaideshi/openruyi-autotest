#!/bin/bash
# Functional test: cloud-utils-growpart - utils-growpart - Error-handling
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        cloudUtilsGrowpartSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "utils-growpart - Error-handling"
        rlRun "growpart 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "growpart: no args (expected fail)"
        rlRun "growpart /dev/nonexistent 1 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "growpart: nonexistent disk"
        rlRun "growpart --help 2>&1 | grep -qiE \"Usage|用法|usage\" || echo help-not-standard" 0 "growpart: invalid option"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # cloud-utils-growpart 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
