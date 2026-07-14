#!/bin/bash

# Functional test: compiler - dejagnu - runtest availablecheck

# verify runtest commandavailable, version infonormal, basicoutput



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 dejagnuSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 rlPhaseEnd



 rlPhaseStartTest "runtest command availability"

 # check runtest whetherexists

 rlRun "which runtest" 0 "runtest Command exists"

 

 # checkversionoutput

 runtest --version 2>&1 | tee /tmp/dejagnu_version.txt

 if grep -qi "dejagnu" /tmp/dejagnu_version.txt; then

 rlPass "runtest --version contains DejaGnu info"

 else

 rlFail "runtest --version outputException"

 fi

 

 # checkoutput

 runtest --help 2>&1 | tee /tmp/dejagnu_help.txt

 if grep -q "\-\-tool" /tmp/dejagnu_help.txt; then

 rlPass "runtest --help contains --tool option"

 else

 rlFail "runtest --help missing --tool option"

 fi

 

 # verifycanby noparameterrun (willerrorbut noshould segfault)

 runtest 2>&1 | tee /tmp/dejagnu_noargs.txt

 local rc=$?

 if [ "$rc" -ne 0 ]; then

 rlPass "runtest noparameterruncorrectexport (non- exit code iscanpre)"

 else

 rlFail "runtest noparameterrunreturn 0"

 fi

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 "Leave temporary directory"

 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"

 rm -f /tmp/dejagnu_version.txt /tmp/dejagnu_help.txt /tmp/dejagnu_noargs.txt

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd

