#!/bin/bash
# Smoke test: scripting - shebang script execution
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeScriptingSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlRun "cat > myscript.sh << 'EOF'" 0 "Create test data"
 rlRun "echo "script ran successfully"" 0 "Create test data"
 rlRun "EOF" 0 "Create test data"
 rlRun "chmod +x myscript.sh" 0 "Create test data"

 rlPhaseEnd

 rlPhaseStartTest "shebang script execution"
 rlRun './myscript.sh' 0 "shebang script execution"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"
 rlRun "cd /" 0 "Leave test directory"
 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
 fi
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd