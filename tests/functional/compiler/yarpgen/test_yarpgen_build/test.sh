#!/bin/bash
# Functional test: compiler - yarpgen - source codebuildand
# Clone yarpgen repolibrary, cmake build, verifyexecutableGenerate

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 yarpgenSetup
 TmpDir=$(mktemp -d)
 rlRun "cd $TmpDir" 0 "Enter temporary directory"
 rlPhaseEnd

 rlPhaseStartTest "YARPGen build verification"
 # checkrepolibrarydirectory
 if [ -d "/tmp/yarpgen" ]; then
 rlPass "yarpgen source codedirectory exists"
 
 # checksource file
 if [ -f "/tmp/yarpgen/CMakeLists.txt" ]; then
 rlPass "CMakeLists.txt exists"
 fi
 
 if [ -d "/tmp/yarpgen/src" ]; then
 rlPass "src directory exists"
 rlRun "ls /tmp/yarpgen/src/" 0 "listexportsource file"
 fi
 else
 rlFail "yarpgen source codedirectorydoes not exist"
 fi
 
 # checkbuilddirectory
 if [ -d "/tmp/yarpgen/build" ]; then
 rlPass "build directory exists"
 else
 rlFail "build directorydoes not exist"
 fi
 
 # check yarpgen executable
 if [ -f "/tmp/yarpgen/build/yarpgen" ]; then
 rlPass "yarpgen executablealreadyGenerate"
 
 # checkfiletype
 rlRun "file /tmp/yarpgen/build/yarpgen" 0 "check yarpgen filetype"
 file /tmp/yarpgen/build/yarpgen | tee /tmp/yarpgen_file.txt
 if grep -qi "ELF" /tmp/yarpgen_file.txt; then
 rlPass "yarpgen is ELF executable"
 fi
 
 # checkversion/help info
 /tmp/yarpgen/build/yarpgen --help 2>&1 | tee /tmp/yarpgen_help.txt
 if [ -s /tmp/yarpgen_help.txt ]; then
 rlPass "yarpgen --help hasoutput"
 fi
 
 # testGenerate random program
 rlRun "/tmp/yarpgen/build/yarpgen 2>&1" 0 "Execute yarpgen Generate random program"
 
 # checkGenerateoutputfile
 local gen_files=0
 for f in init.h func.cpp driver.cpp; do
 if [ -f "$f" ]; then
 gen_files=$((gen_files + 1))
 rlPass "Generate $f ($(wc -l < $f) lines)"
 fi
 done
 
 if [ "$gen_files" -eq 3 ]; then
 rlPass "YARPGen successGenerateall 3 file (init.h + func.cpp + driver.cpp)"
 else
 rlFail "YARPGen onlyGenerate $gen_files/3 file"
 fi
 else
 rlFail "yarpgen executablenotGenerate"
 fi
 rlPhaseEnd

 rlPhaseStartCleanup "Cleanup"
 rlRun "cd /" 0 "Leave temporary directory"
 [ -n "$TmpDir" ] && [ -d "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 "Clean up temporary directory"
 rm -f /tmp/yarpgen_{file,help}.txt
 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd
