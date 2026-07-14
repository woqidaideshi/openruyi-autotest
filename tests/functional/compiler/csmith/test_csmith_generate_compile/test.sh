#!/bin/bash

# Functional test: compiler - csmith - Generateprogramandwith GCC/Clang compile

# Generate Csmith random program, Using respectively gcc and clang compile

# verify: compilewarning count, Compile succeeded, Output is ELF executable



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    csmithSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary directory"

 

    # Generate random program

    rlRun "csmith > csmith_test.c 2>/dev/null" 0 "Generate random C program"

    rlAssertExists "csmith_test.c"

    rlLogInfo "C programsize: $(wc -l < csmith_test.c) lines"

    rlPhaseEnd



    rlPhaseStartTest "GCC compile"

    # GCC compile (record stderr viewwarning count)

    gcc -O2 csmith_test.c -o csmith_gcc -w 2>/tmp/csmith_gcc_err.txt

    local gcc_rc=$?

    rlRun "echo \"GCC exit: $gcc_rc\"" 0 "GCC compileexit code: $gcc_rc"

 

    if [ "$gcc_rc" -eq 0 ] && [ -x./csmith_gcc ]; then

    rlPass "GCC Compile succeeded"

 

    # verifyis ELF executable

    rlRun "file./csmith_gcc" 0 "checkcompiletype"

    file./csmith_gcc | tee /tmp/csmith_file_gcc.txt

    if grep -qi "ELF" /tmp/csmith_file_gcc.txt; then

    rlPass "GCC Output is ELF executable"

    else

    rlFail "GCC nois ELF format"

    fi

 

    # Check compile warnings

    if [ -s /tmp/csmith_gcc_err.txt ]; then

    local warn_count

    warn_count=$(grep -c "warning:" /tmp/csmith_gcc_err.txt 2>/dev/null || echo 0)

    rlLogInfo "GCC compileproduced $warn_count warning"

    else

    rlPass "GCC compilenowarning/erroroutput"

    fi

    else

    rlFail "GCC Compile failed"

    fi

    rlPhaseEnd



    rlPhaseStartTest "Clang compile"

    clang -O2 csmith_test.c -o csmith_clang -w 2>/tmp/csmith_clang_err.txt

    local clang_rc=$?

    rlRun "echo \"Clang exit: $clang_rc\"" 0 "Clang compileexit code: $clang_rc"

 

    if [ "$clang_rc" -eq 0 ] && [ -x./csmith_clang ]; then

    rlPass "Clang Compile succeeded"

 

    rlRun "file./csmith_clang" 0 "checkcompiletype"

    file./csmith_clang | tee /tmp/csmith_file_clang.txt

    if grep -qi "ELF" /tmp/csmith_file_clang.txt; then

    rlPass "Clang Output is ELF executable"

    else

    rlFail "Clang nois ELF format"

    fi

 

    if [ -s /tmp/csmith_clang_err.txt ]; then

    local warn_count

    warn_count=$(grep -c "warning:" /tmp/csmith_clang_err.txt 2>/dev/null || echo 0)

    rlLogInfo "Clang compileproduced $warn_count warning"

    else

    rlPass "Clang compilenowarning/erroroutput"

    fi

    else

    rlFail "Clang Compile failed"

    fi

    rlPhaseEnd



    rlPhaseStartCleanup "Cleanup"

    rlRun "cd /" 0 "Leave temporary directory"

    [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"

    rm -f /tmp/csmith_{gcc,clang}_{err,file}.txt

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd

