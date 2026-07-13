#!/bin/bash
# Smoke test: dev_tools - make version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeDevToolsSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary test directory"
 cat > Makefile << 'EOF'
 hello: hello.c
 $(CC) -o hello hello.c
 EOF
 echo 'int main(){return 0;}' > hello.c

 rlPhaseEnd

 rlPhaseStartTest "make version"
 rlRun 'make --version' 0 "make version"
 rlRun 'make CC=gcc hello' 0 "make build"
 rlRun 'test -f hello' 0 "make outputexists"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd