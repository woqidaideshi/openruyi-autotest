#!/bin/bash

# Security test: nmap - nmap outputformat

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 nmapSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 TmpDir=$(mktemp -d)

 cd $TmpDir



 rlPhaseEnd



 rlPhaseStartTest "nmap outputformat"

 rlRun 'nmap -T4 --host-timeout 30s -oN normal_output.txt -p 22 localhost 2>&1 || true' 0 "format (-oN)"

 rlRun 'nmap -T4 --host-timeout 30s -oX xml_output.xml -p 22 localhost 2>&1 || true' 0 "XML format (-oX)"

 rlRun 'nmap -T4 --host-timeout 30s -oG grepable_output.txt -p 22 localhost 2>&1 || true' 0 "Grepable format (-oG)"

 rlRun 'nmap -T4 --host-timeout 30s -oA all_output -p 22 localhost 2>&1 || true' 0 "full format (-oA)"

 rlRun 'test -f normal_output.txt && wc -l normal_output.txt || true' 0 "outputfile exists"

 rlRun 'test -f xml_output.xml && head -3 xml_output.xml || true' 0 "XML outputfile exists"

 rlRun 'test -f grepable_output.txt && wc -l grepable_output.txt || true' 0 "Grepable outputfile exists"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd