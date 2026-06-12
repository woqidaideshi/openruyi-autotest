"""Upload all test scripts to server and run in parallel, collect results."""
import paramiko, os, time

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'
BASE = r'e:\code\openruyi-autotest\tests\functional'

print('=== Step 1: Connect ===')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)
ssh.exec_command('mkdir -p /home/openruyi/functional-tests')

# Step 1: Upload all tests (CRLF -> LF)
print('=== Step 2: Upload tests with LF conversion ===')
count = 0
for root, dirs, files in os.walk(BASE):
    if 'test.sh' not in files:
        continue
    pkg = root.replace('\\', '/').split('/')[-1]
    parent = root.replace('\\', '/').split('/')[-2]
    tid = f'{parent}__{pkg}' if parent != 'functional' else pkg
    
    local = os.path.join(root, 'test.sh')
    remote = f'/home/openruyi/functional-tests/{tid}.sh'
    
    with open(local, 'rb') as f:
        raw = f.read()
    text = raw.replace(b'\r\n', b'\n').replace(b'\r', b'\n')
    
    sftp = ssh.open_sftp()
    with sftp.file(remote, 'wb') as f:
        f.write(text)
    sftp.chmod(remote, 0o755)
    sftp.close()
    count += 1

print(f'Uploaded {count} test scripts')

# Step 2: Create server-side parallel runner
print('=== Step 3: Start parallel run on server ===')
runner = f'''#!/bin/bash
cd /home/openruyi/functional-tests
rm -f results.txt
echo "Starting parallel test run..." > /home/openruyi/run_status.txt

total=0
for f in $(ls *.sh 2>/dev/null | grep -v '\\.log$' | sort); do
    name="${{f%.sh}}"
    (
        timeout 30 bash "$f" > "${{f}}.log" 2>&1
        rc=$?
        if [ $rc -eq 0 ]; then
            echo "PASS|$name" >> results.txt
        else
            echo "FAIL|$name" >> results.txt
        fi
    ) &
    total=$((total+1))
    
    # Limit to 25 parallel
    while [ $(jobs -r | wc -l) -ge 25 ]; do sleep 1; done
done
wait

p=$(grep -c "^PASS|" results.txt 2>/dev/null || echo 0)
f=$(grep -c "^FAIL|" results.txt 2>/dev/null || echo 0)
echo "DONE|total=$total|passed=$p|failed=$f" >> results.txt
echo "DONE" > /home/openruyi/run_status.txt
'''

sftp = ssh.open_sftp()
with sftp.file('/home/openruyi/run_all.sh', 'w') as f:
    f.write(runner)
sftp.chmod('/home/openruyi/run_all.sh', 0o755)
sftp.close()

# Clear old results and start
ssh.exec_command('rm -f /home/openruyi/functional-tests/results.txt')
ssh.exec_command('nohup bash /home/openruyi/run_all.sh > /home/openruyi/run_all.out 2>&1 &')
time.sleep(3)

# Step 3: Poll for completion
print('=== Step 4: Polling for completion ===')
for i in range(120):
    time.sleep(5)
    stdin, stdout, stderr = ssh.exec_command('cat /home/openruyi/run_status.txt 2>/dev/null', timeout=10)
    status = stdout.read().decode(errors='replace').strip()
    
    # Show progress
    stdin, stdout, stderr = ssh.exec_command('wc -l < /home/openruyi/functional-tests/results.txt 2>/dev/null || echo 0', timeout=10)
    lines = stdout.read().decode(errors='replace').strip()
    
    if status == 'DONE':
        print(f'\nDone! {lines} results')
        break
    if i % 12 == 0:
        print(f'  [{i*5}s] {lines} results so far...')

# Step 4: Collect results
print('\n=== Step 5: Results ===')
stdin, stdout, stderr = ssh.exec_command('cat /home/openruyi/functional-tests/results.txt 2>/dev/null', timeout=10)
all_results = stdout.read().decode(errors='replace').strip().split('\n')

pass_list = [l for l in all_results if l.startswith('PASS|')]
fail_list = [l for l in all_results if l.startswith('FAIL|')]
done_line = [l for l in all_results if l.startswith('DONE|')]

print(f'PASS: {len(pass_list)}, FAIL: {len(fail_list)}')
if done_line:
    print(done_line[0])

if fail_list:
    print(f'\nFailed tests ({len(fail_list)}):')
    for fl in fail_list[:30]:
        name = fl.split('|', 1)[1]
        print(f'  {name}')
    if len(fail_list) > 30:
        print(f'  ... and {len(fail_list)-30} more')
    
    # Get logs for first few failures
    print('\n=== Sample failure logs ===')
    for fl in fail_list[:5]:
        name = fl.split('|', 1)[1]
        stdin, stdout, stderr = ssh.exec_command(f'tail -10 /home/openruyi/functional-tests/{name}.sh.log 2>/dev/null', timeout=10)
        log = stdout.read().decode(errors='replace').strip()
        print(f'\n--- {name} ---')
        print(log[-300:])

ssh.close()
print('\nDone.')
