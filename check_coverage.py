import subprocess

cmd = "rpm -ql coreutils | grep '^/usr/bin/' | awk -F/ '{print $NF}' | sort"
result = subprocess.run([
    'python', '.trellis/scripts/ssh_exec.py',
    '10.20.237.192', 'openruyi', 'openruyi',
    cmd, '--port', '12055', '--timeout', '30', '--sudo'
], capture_output=True, text=True, timeout=60)
print(result.stdout)