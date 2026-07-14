#!/bin/bash

# Functional test: compiler - csmith - installation and availability check

# verify Csmith commandavailable, version infocorrect, canGenerate random C program



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 csmithSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 rlPhaseEnd



 rlPhaseStartTest "Csmith installation verification"

 # checkcommandwhetherexists

 rlRun "which Csmith" 0 "Csmith Command exists"

 

 # checkversion info

 csmith --version 2>&1 | tee /tmp/csmith_version.txt

 if grep -qi "csmith\|version" /tmp/csmith_version.txt; then

 rlPass "csmith --version outputnormal"

 else

 rlFail "csmith --version outputException"

 fi

 

 # Generate random C program

 rlRun "csmith > random1.c 2>/tmp/csmith_stderr.txt" 0 "Generate random C program"

 

 # verifyGenerate C filenon-andcorrect

 if [ -s random1.c ]; then

 local lines

 lines=$(wc -l < random1.c)

 rlPass "Csmith Generate C program ($lines lines)"

 

 # Check if contains main function

 if grep -q "int main" random1.c; then

 rlPass "Generateprogramcontains main function"

 else

 rlFail "Generateprogrammissing main function"

 fi

 

 # Check if contains C Standardheaderfilereference

 if grep -q "#include" random1.c; then

 rlPass "Generateprogramcontainsheaderfilereference"

 fi

 else

 rlFail "Csmith notGeneratehas C program"

 fi

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 "Leave temporary directory"

 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"

 rm -f /tmp/csmith_version.txt /tmp/csmith_stderr.txt

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd

