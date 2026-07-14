#!/bin/bash

# Reliability: trinity - excludemode (-x)

# Example: trinity -x splice (excludealreadyissue syscall)

# exclude syscall postExecutefull fuzz

. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 trinitySetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary directory"

 TAINT_BEFORE=$(_trinityTaintBefore)

 chmod 777 "$TmpDir"



 # exclude syscall list

 DANGEROUS="reboot shutdown init_module delete_module mount umount2 mknod swapon swapoff ioperm iopl kexec_load kexec_file_load"

 rlLogInfo "exclude syscall: $DANGEROUS"

 rlPhaseEnd



 rlPhaseStartTest "excludeall syscall"

 local log="$TmpDir/trinity_exclude.log"

 # build -x parameter

 local exclude_args=""

 for call in $DANGEROUS; do

 exclude_args="$exclude_args -x $call"

 done



 timeout 45 sudo -u "$TRINITY_USER" trinity -q $exclude_args -N 20000 > "$log" 2>&1

 local rc=$?



 rlLogInfo "excludemodeexit code: $rc"



 if [ "$rc" -eq 0 ] || [ "$rc" -eq 124 ]; then

 rlPass "excludecallwithpost Trinity normalrun"

 else

 rlLogWarning "excludemodeException: $rc"

 fi



 # verifyexcludecallwithnotexport

 local leak=0

 for call in $DANGEROUS; do

 if grep -qiw "$call" "$log" 2>/dev/null; then

 rlLogWarning "exclude: $call"

 leak=1

 fi

 done

 if [ "$leak" -eq 0 ]; then

 rlPass "all syscall successexclude"

 fi



 _trinityCheckOutput "$log"

 rlPhaseEnd



 rlPhaseStartTest "tainted check"

 _trinityTaintCheck "$TAINT_BEFORE"

 rlPhaseEnd



 rlPhaseStartCleanup "Cleanup"

 rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""

 rlPhaseEnd

 rlJournalPrintText

rlJournalEnd

