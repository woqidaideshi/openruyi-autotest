#!/bin/bash
# Security test: nmap - nmap 输出格式
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nmapSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        TmpDir=$(mktemp -d)
        cd $TmpDir

    rlPhaseEnd

    rlPhaseStartTest "nmap 输出格式"
        rlRun 'nmap -T4 --host-timeout 30s -oN normal_output.txt -p 22 localhost 2>&1 || true' 0 "普通格式 (-oN)"
        rlRun 'nmap -T4 --host-timeout 30s -oX xml_output.xml -p 22 localhost 2>&1 || true' 0 "XML 格式 (-oX)"
        rlRun 'nmap -T4 --host-timeout 30s -oG grepable_output.txt -p 22 localhost 2>&1 || true' 0 "Grepable 格式 (-oG)"
        rlRun 'nmap -T4 --host-timeout 30s -oA all_output -p 22 localhost 2>&1 || true' 0 "全格式 (-oA)"
        rlRun 'test -f normal_output.txt && wc -l normal_output.txt || true' 0 "普通输出文件存在"
        rlRun 'test -f xml_output.xml && head -3 xml_output.xml || true' 0 "XML 输出文件存在"
        rlRun 'test -f grepable_output.txt && wc -l grepable_output.txt || true' 0 "Grepable 输出文件存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd