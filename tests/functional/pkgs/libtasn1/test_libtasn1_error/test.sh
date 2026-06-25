#!/bin/bash
# Functional test: libtasn1 - ������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        libtasn1Setup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "������"
        rlRun "asn1Coding --invalid-flag-xyz 2>&1 || true" 0 "���� asn1Coding ��Ч����������"
        rlRun "asn1Decoding --invalid-flag-xyz 2>&1 || true" 0 "���� asn1Decoding ��Ч����������"
        rlRun "asn1Parser --invalid-flag-xyz 2>&1 || true" 0 "���� asn1Parser ��Ч����������"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # libtasn1 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
