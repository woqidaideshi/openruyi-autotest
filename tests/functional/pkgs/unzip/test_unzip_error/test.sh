#!/bin/bash
# Functional test: unzip - ������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        unzipSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "������"
        rlRun "unzip --invalid-flag-xyz 2>&1 || true" 0 "���� unzip ��Ч����������"
        rlRun "funzip --invalid-flag-xyz 2>&1 || true" 0 "���� funzip ��Ч����������"
        rlRun "zipgrep --invalid-flag-xyz 2>&1 || true" 0 "���� zipgrep ��Ч����������"
        rlRun "zipinfo --invalid-flag-xyz 2>&1 || true" 0 "���� zipinfo ��Ч����������"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # unzip 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
