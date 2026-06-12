#!/bin/sh -eux
# Functional test: coreutils - Environment-and-time--env--printenv--date--printf

rlRun() { eval "$1" 2>&1; return $?; }
rlRun 'rpm -q coreutils' 0 "Check coreutils package is installed"
TmpDir=$(mktemp -d)
cd $TmpDir

echo "=== Test 17: Environment and time (env, printenv, date, printf) ==="

# 17.1 env
rlRun 'env' 0 "env show environment"
rlRun 'env PATH=/usr/bin echo test' 0 "env set variable for command"

# 17.2 printenv
rlRun 'printenv PATH' 0 "printenv show PATH"

# 17.3 date
rlRun 'date' 0 "date current date/time"
rlRun 'date +%Y-%m-%d' 0 "date custom format"
rlRun 'date -u' 0 "date -u UTC time"

# 17.4 printf
rlRun 'printf "%s %d\n" hello 42' 0 "printf formatted output"
rlRun 'test "$(printf "%s" one two)" = "onetwo"' 0 "printf string output"

# ===================================================================

echo ""
echo "All coreutils Environment-and-time--env--printenv--date--printf tests passed!"
