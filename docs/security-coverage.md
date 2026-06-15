# 安全测试覆盖详情

> 最后更新: 2026-06-15 | 自动生成
> 测试环境: openEuler RISC-V (10.20.237.192)

共 **2** 个安全测试套件，**106** 个测试用例，**124** 个功能点

## 安全测试套件一览

| 测试套件 | 用例数 | 功能点 | PASS | FAIL | SKIP | TIMEOUT | 类型 |
|----------|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| [nmap](#nmap) | 8 | 26 | 8 | 0 | 0 | 0 | rlRun |
| [cve](#cve) | 98 | 98 | 38 | 7 | 47 | 6 | LTP |

---

## nmap

<details>
<summary><b>nmap — 8 个用例 / 26 个功能点</b></summary>

#### test_nmap_basic_scan

- TCP 端口扫描 (常用端口)
- UDP 端口扫描 (DNS)
- TCP 端口扫描 (1-100)

#### test_nmap_service_detection

- SSH 服务版本检测
- 服务版本探测

#### test_nmap_os_detection

- 操作系统指纹识别
- 限制型 OS 检测

#### test_nmap_script_scan

- NSE banner 脚本
- NSE HTTP 头检测
- NSE SSH 认证方法检测
- NSE SSL 密码套件枚举

#### test_nmap_firewall_evasion

- 分片包扫描 (fragment)
- 随机数据填充扫描
- 错误校验和探测

#### test_nmap_network_discovery

- Ping 扫描 (主机发现)
- ICMP Echo 发现
- TCP SYN Ping 发现

#### test_nmap_ssl_analysis

- SSL 证书分析
- Heartbleed 漏洞检测
- SSLv2 支持检测

#### test_nmap_output_formats

- 普通格式输出 (-oN)
- XML 格式输出 (-oX)
- Grepable 格式输出 (-oG)
- 全格式输出 (-oA)
- 普通输出文件存在
- XML 输出文件存在
- Grepable 输出文件存在

</details>

## 安全测试覆盖场景

| 场景类别 | 覆盖内容 | nmap 命令示例 |
|----------|---------|-------------|
| **端口扫描** | TCP/UDP 端口发现 | `nmap -T4 -p 1-100` / `nmap -sU -p 53` |
| **服务检测** | 服务版本识别 | `nmap -sV -p 22` |
| **OS 指纹** | 操作系统识别 | `nmap -O --osscan-limit` |
| **NSE 脚本** | 漏洞/信息探测 | `nmap --script=banner,ssl-enum-ciphers` |
| **规避技术** | 防火墙/IDS 绕过 | `nmap -f` / `nmap --data-length` / `nmap --badsum` |
| **主机发现** | 存活主机探测 | `nmap -sn` / `nmap -PE` / `nmap -PS` |
| **SSL/TLS** | 证书/密码分析 | `nmap --script=ssl-cert,ssl-heartbleed,sslv2` |
| **输出格式** | 多格式报告 | `nmap -oN/-oX/-oG/-oA` |

---

## cve

<details>
<summary><b>cve — 98 个用例 / 98 个功能点（38P / 7F / 47S / 6T）</b></summary>

> **数据来源**: [LTP (Linux Test Project)](https://github.com/linux-test-project/ltp) runtest/cve
> **测试方式**: 每个 CVE 对应一个 LTP 内核测试程序，验证系统是否已修复相关漏洞
> **实事求是**: PASS=系统已修复该漏洞；FAIL=系统仍存在该漏洞或测试检测到问题；SKIP=测试不适用于 RISC-V 架构；TIMEOUT=测试挂起无法判定

### PASS（系统已修复，38 个）

| CVE ID | LTP 测试 | CVE ID | LTP 测试 |
|--------|----------|--------|----------|
| cve-2012-0957 | uname04 | cve-2014-0196 | cve-2014-0196 |
| cve-2015-0235 | gethostbyname_r01 | cve-2016-10044 | cve-2016-10044 |
| cve-2016-7042 | cve-2016-7042 | cve-2016-7117 | cve-2016-7117 |
| cve-2017-1000111 | setsockopt07 | cve-2017-1000112 | setsockopt05 |
| cve-2017-12192 | keyctl07 | cve-2017-12193 | add_key04 |
| cve-2017-15274 | add_key02 | cve-2017-16939 | cve-2017-16939 |
| cve-2017-17052 | cve-2017-17052 | cve-2017-17712 | sendmsg03 |
| cve-2017-17806 | af_alg01 | cve-2017-17807 | request_key04 |
| cve-2017-18344 | timer_create03 | cve-2017-2618 | cve-2017-2618 |
| cve-2017-6951 | request_key05 | cve-2017-7472 | keyctl04 |
| cve-2017-8890 | accept02 | cve-2018-11508 | adjtimex03 |
| cve-2018-12896 | timer_settime03 | cve-2018-19854 | crypto_user01 |
| cve-2018-6927 | futex_cmp_requeue02 | cve-2018-9568 | connect02 |
| cve-2019-8912 | af_alg07 | cve-2020-14386 | sendto03 |
| cve-2020-25705 | icmp_rate_limit01 | cve-2021-22600 | setsockopt09 |
| cve-2021-26708 | vsock01 | cve-2021-4034 | execve06 |
| cve-2022-0847 | dirtypipe | cve-2022-4378 | cve-2022-4378 |
| cve-2023-0461 | setsockopt10 | cve-2023-31248 | nft02 |
| cve-2025-21756 | cve-2025-21756 | cve-2025-38236 | cve-2025-38236 |

### FAIL（系统未修复或存在风险，7 个）

| CVE ID | LTP 测试 | 退出码 | 说明 |
|--------|----------|:---:|------|
| cve-2017-15299 | request_key03 | 2 | 内核密钥管理服务漏洞 |
| cve-2017-15951 | request_key03 | 2 | 内核密钥管理服务漏洞 |
| cve-2026-31431 | af_alg08 | 1 | AF_ALG 加密套接字漏洞 |
| cve-2026-43284 | xfrm01 | 1 | XFRM 网络变换框架漏洞 |
| cve-2026-43494 | io_uring04 | 1 | io_uring 异步 I/O 漏洞 |
| cve-2026-46300-skb-segment | xfrm03 | 1 | XFRM skb 分段漏洞 |
| cve-2026-46300 | xfrm02 | 1 | XFRM 网络变换框架漏洞 |

### TIMEOUT（测试挂起，无法判定，6 个）

| CVE ID | LTP 测试 | 超时(秒) |
|--------|----------|:---:|
| cve-2016-8655 | setsockopt06 | 90 |
| cve-2017-1000380 | snd_timer01 | 90 |
| cve-2017-1000405 | thp04 | 90 |
| cve-2017-10661 | timerfd_settime02 | 90 |
| cve-2017-2636 | pty05 | 90 |
| cve-2018-18559 | bind06 | 90 |

### SKIP（不适用于 RISC-V 架构，47 个）

cve-2011-0999, cve-2011-2183, cve-2011-2496, cve-2015-3290, cve-2015-7550, cve-2016-4470, cve-2016-4997, cve-2016-5195, cve-2016-9604, cve-2016-9793, cve-2017-1000364, cve-2017-15537, cve-2017-15649, cve-2017-16995, cve-2017-17053, cve-2017-17805, cve-2017-18075, cve-2017-2671, cve-2017-5754, cve-2017-7308, cve-2017-7616, cve-2018-1000001, cve-2018-1000199, cve-2018-1000204, cve-2018-10124, cve-2018-13405, cve-2018-18445, cve-2018-18955, cve-2018-5803, cve-2018-7566, cve-2018-8897, cve-2020-11494, cve-2020-14416, cve-2020-25704, cve-2020-29373, cve-2020-36557, cve-2021-22555, cve-2021-3444, cve-2021-3609, cve-2021-38604, cve-2021-4197_1, cve-2021-4197_2, cve-2021-4204, cve-2022-0185, cve-2022-23222, cve-2022-2590, cve-2023-1829

</details>

---

## 运行安全测试

```bash
# 单独运行 nmap 安全测试
cd tests/security/nmap && bash test.sh

# 运行 CVE 安全测试（需 LTP 环境）
cd tests/security/cve && bash run_all.sh

# 在服务器上运行
ssh openruyi@10.20.237.192 -p 12055
cd /path/to/tests/security/nmap && bash test.sh
```

## 安全说明

- 所有测试仅针对 localhost (127.0.0.1) 执行，不会扫描外部网络
- 部分功能（OS 指纹识别）需要 root 权限，非 root 环境下会自动跳过
- 扫描使用 `-T4` 和 `--host-timeout` 参数控制时间
- 如发现危险端口开放（telnet 23、FTP 21、RDP 3389 等），测试会发出警告
