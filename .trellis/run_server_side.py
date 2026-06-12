"""Upload a server-side parallel runner, execute all tests, download results."""
import paramiko, time, csv, os

SERVER='10.20.237.192';PORT=12055;USER='openruyi';PASS='openruyi'

# Server-side parallel runner
runner = r"""#!/bin/bash
# Parallel test runner - runs all tests in /home/openruyi/tc/
cd /home/openruyi/tc
rm -f /home/openruyi/tc/results.csv
PARALLEL=25

total=0
for f in $(ls *.sh 2>/dev/null | grep -v '\.log$' | sort); do
    name="${f%.sh}"
    pkg="${name%%__*}"
    case="${name#*__}"
    
    # Run test in background
    (timeout 60 bash "$f" > "${f}.log" 2>&1
     if tail -1 "${f}.log" 2>/dev/null | grep -qi "tests passed"; then
         echo "$pkg,$case,PASS" >> /home/openruyi/tc/results.csv
     else
         echo "$pkg,$case,FAIL" >> /home/openruyi/tc/results.csv
     fi
    ) &
    total=$((total+1))
    
    # Wait if we have PARALLEL jobs running
    while [ $(jobs -r | wc -l) -ge $PARALLEL ]; do
        sleep 2
    done
done

# Wait for remaining jobs
wait
echo "DONE: total=$total" >> /home/openruyi/tc/results.csv
echo "TOTAL=$total"
"""

print("Connecting to server...")
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)

# Upload runner script
print("Uploading runner script...")
sftp = ssh.open_sftp()
with sftp.file('/home/openruyi/run_all.sh', 'w') as f:
    f.write(runner)
sftp.chmod('/home/openruyi/run_all.sh', 0o755)
sftp.close()

# Clear old results and start
print("Starting parallel test run on server...")
ssh.exec_command('rm -f /home/openruyi/tc/results.csv; nohup bash /home/openruyi/run_all.sh > /home/openruyi/run_all.out 2>&1 &')
time.sleep(2)

# Poll for completion
print("Polling for completion...")
max_wait = 1200  # 20 minutes max
interval = 20
waited = 0
while waited < max_wait:
    time.sleep(interval)
    waited += interval
    stdin, stdout, stderr = ssh.exec_command('tail -1 /home/openruyi/tc/results.csv 2>/dev/null')
    last = stdout.read().decode().strip()
    
    # Count current results
    stdin, stdout, stderr = ssh.exec_command("grep -c ',PASS\|,FAIL' /home/openruyi/tc/results.csv 2>/dev/null || echo 0")
    count = stdout.read().decode().strip()
    
    if last.startswith('DONE:'):
        print(f'\nCompleted! {last} - {count} results')
        break
    print(f'  {waited}s: {count} results so far')

# Download results
print("\nDownloading results...")
stdin, stdout, stderr = ssh.exec_command('cat /home/openruyi/tc/results.csv')
data = stdout.read().decode().strip()

# Parse and write local CSV
results = []
for line in data.split('\n'):
    if line.startswith('DONE:') or not line.strip():
        continue
    parts = line.split(',')
    if len(parts) >= 3:
        results.append(parts)

csv_path = 'docs/test_report.csv'
with open(csv_path, 'w', newline='', encoding='utf-8-sig') as f:
    w = csv.writer(f)
    w.writerow(['测试套', '测试用例', '测试结果'])
    for row in results:
        w.writerow(row)

tp = sum(1 for r in results if r[2] == 'PASS')
print(f'Total: {tp}/{len(results)} passed')
print(f'CSV written to {csv_path}')
ssh.close()
