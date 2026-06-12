"""Upload fixed tests with setup/teardown, run in parallel, collect results."""
import paramiko, os, tarfile, io, time

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'
BASE = r'e:\code\openruyi-autotest\tests\functional'

print('Creating tar.gz...')
buf = io.BytesIO()
with tarfile.open(fileobj=buf, mode='w:gz') as tar:
    for root, dirs, files in os.walk(BASE):
        if 'test.sh' not in files: continue
        pkg = root.replace('\\', '/').split('/')[-1]
        parent = root.replace('\\', '/').split('/')[-2]
        tid = f'{parent}__{pkg}' if parent != 'functional' else pkg
        local = os.path.join(root, 'test.sh')
        with open(local, 'rb') as f: raw = f.read()
        text = raw.replace(b'\r\n', b'\n').replace(b'\r', b'\n')
        info = tarfile.TarInfo(name=f'{tid}.sh'); info.size = len(text); info.mode = 0o755
        tar.addfile(info, io.BytesIO(text))
print(f'Tar: {len(buf.getvalue())} bytes')

print('Uploading...')
ssh = paramiko.SSHClient(); ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)
sftp = ssh.open_sftp()
with sftp.file('/home/openruyi/tests.tar.gz', 'wb') as f: f.write(buf.getvalue())
sftp.close()
ssh.exec_command('mkdir -p /home/openruyi/ft && cd /home/openruyi/ft && rm -f *.sh *.log results.txt && tar xzf /home/openruyi/tests.tar.gz && rm /home/openruyi/tests.tar.gz && ls *.sh|wc -l', timeout=30)
time.sleep(2)

# Runner script
runner = """#!/bin/bash
cd /home/openruyi/ft
rm -f results.txt
total=0
for f in $(ls *.sh 2>/dev/null | sort); do
    name="${f%.sh}"
    ( timeout 60 bash "$f" > "${f}.log" 2>&1; rc=$?;
      if grep -qi "skip:" "${f}.log" 2>/dev/null; then echo "SKIP|$name" >> results.txt
      elif [ $rc -eq 0 ]; then echo "PASS|$name" >> results.txt
      else echo "FAIL|$name" >> results.txt; fi ) &
    total=$((total+1))
    while [ $(jobs -r | wc -l) -ge 25 ]; do sleep 1; done
done
wait
p=$(grep -c "^PASS|" results.txt); s=$(grep -c "^SKIP|" results.txt); f=$(grep -c "^FAIL|" results.txt)
echo "DONE|total=$total|pass=$p|skip=$s|fail=$f" >> results.txt
"""

sftp = ssh.open_sftp()
with sftp.file('/home/openruyi/ft/run.sh', 'w') as f: f.write(runner)
sftp.chmod('/home/openruyi/ft/run.sh', 0o755); sftp.close()
ssh.exec_command('nohup bash /home/openruyi/ft/run.sh > /home/openruyi/ft/out.txt 2>&1 &')
print('Started. Polling...')

for i in range(80):
    time.sleep(5)
    stdin, stdout, stderr = ssh.exec_command(
        'L=$(wc -l < /home/openruyi/ft/results.txt 2>/dev/null || echo 0); '
        'P=$(grep -c "^PASS|" /home/openruyi/ft/results.txt 2>/dev/null || echo 0); '
        'S=$(grep -c "^SKIP|" /home/openruyi/ft/results.txt 2>/dev/null || echo 0); '
        'F=$(grep -c "^FAIL|" /home/openruyi/ft/results.txt 2>/dev/null || echo 0); '
        'R=$(ps aux|grep "ft/run.sh"|grep -v grep|wc -l); '
        'echo "$L $P $S $F $R"', timeout=15)
    parts = stdout.read().decode().strip().split()
    if len(parts) >= 5:
        L,P,S,F,R = parts
        if i%6==0: print(f'  [{i*5}s] total={L} pass={P} skip={S} fail={F} running={R}')
        if R == '0' and L != '0': break

stdin, stdout, stderr = ssh.exec_command('tail -1 /home/openruyi/ft/results.txt', timeout=10)
print('\nFINAL:', stdout.read().decode().strip())
stdin, stdout, stderr = ssh.exec_command('grep "^FAIL|" /home/openruyi/ft/results.txt || echo NO_FAILURES', timeout=10)
fails = stdout.read().decode(errors='replace')
if 'NO_FAILURES' not in fails:
    fl = [l.split('|',1)[1] for l in fails.strip().split('\n')]
    print(f'FAILURES ({len(fl)}):')
    for f in fl: print(f'  {f}')
else:
    print('ALL PASSED!')

ssh.close()