#!/bin/bash
# Smoke test: dev_tools - gcc available
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeDevToolsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 cat > hello.c << 'EOF'
 #include <stdio.h>
 int main() { printf("smoke test"); return 0; }
 EOF

 rlPhaseEnd

 rlPhaseStartTest "gcc available"
 rlRun 'which gcc' 0 "gcc available"
 rlRun 'gcc hello.c -o hello' 0 "gcc compile"
 rlRun './hello' 0 "compileresultcanExecute"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd