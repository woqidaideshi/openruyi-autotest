import subprocess, base64

test_sh = 'e:/code/openruyi-autotest/tests/functional/coreutils/test.sh'
with open(test_sh, 'r', encoding='utf-8') as f:
    content = f.read()
encoded = base64.b64encode(content.encode()).decode()
cmd = f'echo {encoded} | base64 -d > /tmp/test_coreutils.sh && chmod +x /tmp/test_coreutils.sh && timeout 180 bash /tmp/test_coreutils.sh 2>&1'

result = subprocess.run([
    'python', '.trellis/scripts/ssh_exec.py',
    '10.20.237.192', 'openruyi', 'openruyi',
    cmd, '--port', '12055', '--timeout', '240', '--sudo'
], capture_output=True, text=True, timeout=300)

stdout = result.stdout
print('=== LAST 20 LINES ===')
for line in stdout.split('\n')[-20:]:
    print(line)
print('=== RESULT ===')
if 'All coreutils functional tests passed!' in stdout:
    print('PASS: All coreutils functional tests passed!')
else:
    print('FAIL: Check output above')
    for line in stdout.split('\n')[-30:]:
        if 'error' in line.lower() or 'fail' in line.lower() or 'fatal' in line.lower() or 'BAD' in line:
            print(f'  ERR: {line}')