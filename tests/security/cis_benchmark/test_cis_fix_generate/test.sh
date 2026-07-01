#!/bin/bash
# Security test: cis_benchmark - fix_generate
# CIS Benchmark: 生成 CIS 修复脚本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname $0)/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment Setup"
        cisBenchmarkSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "Enter tmp dir"
    rlPhaseEnd

    rlPhaseStartTest "CIS Benchmark - fix_generate"
        rlRun "_cisFixGenerate" 0 "Run 生成 CIS 修复脚本"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        rlRun "cd /" 0 "Leave tmp dir"
        [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean tmp"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
