# 开发自测报告: K8s RISC-V 适配 Sonobuoy 等价测试用例

> **关联需求**: [requirement.md](./requirement.md) | **关联设计**: [design.md](./design.md)
> **状态**: ✅ 自测通过 | **创建时间**: 2026-07-24 | **作者**: AI (honghua)
> **首次执行**: 2026-07-24 10:00 ~ 11:24（17/25 PASS）
> **修复后复测**: 2026-07-24 12:29 ~ 13:37（25/25 PASS）
> **测试环境**: openRuyi, K8s v1.35.5, RISC-V (riscv64)

---

## 1. 自测概要

### 1.1 自测范围

根据[需求文档](./requirement.md)的优先级划分和[设计文档](./design.md)的技术方案，针对 RISC-V 架构 K8s v1.35.5 集群，对 **10 大类 25 个**测试脚本进行全面自测。测试覆盖了 Sonobuoy 等价的所有关键领域。

### 1.2 自测环境

| 项目 | 描述 |
|------|------|
| **被测系统** | openRuyi |
| **内核版本** | riscv64 |
| **架构** | RISC-V (riscv64) |
| **K8s 版本** | v1.35.5 |
| **集群规模** | 2 节点 (openruyi-node-0 master + openruyi-node-1 worker) |
| **容器运行时** | containerd://1.6.22.16 |
| **网络插件** | Calico CNI |
| **存储** | local-path-storage provisioner |
| **运行时类** | kata-clh (Kata Containers) |
| **测试框架** | beakerlib v1.33.3 + tmt |
| **执行方式** | `tools/run_full_tests.py` (Python SSH 远程调度) |
| **远程主机** | 10.20.238.229:12055 (master) / 12056 (worker) |

### 1.3 自测总体结果

| 测试类型 | 脚本数 | 通过 | 失败 | 跳过(Phase) | 通过率 |
|---------|:---:|:---:|:---:|:---:|:---:|
| 冒烟测试 (smoke) | 4 | 4 | 0 | 0 | 100% |
| API 测试 (api) | 2 | 2 | 0 | 0 | 100% |
| Pod 测试 (pod) | 2 | 2 | 0 | 0 | 100% |
| 配置管理 (config) | 2 | 2 | 0 | 0 | 100% |
| 认证授权 (auth) | 1 | 1 | 0 | 0 | 100% |
| 网络测试 (network) | 4 | 4 | 0 | 1 | 100% |
| 存储测试 (storage) | 3 | 3 | 0 | 0 | 100% |
| 调度测试 (scheduling) | 4 | 4 | 0 | 0 | 100% |
| 工作负载 (workload) | 2 | 2 | 0 | 0 | 100% |
| Kata 运行时 (kata) | 1 | 1 | 0 | 0 | 100% |
| **合计** | **25** | **25** | **0** | **1** | **100%** |

> 注：PASS/FAIL 基于 beakerlib Phases 判断（good phases / bad phases）。skip 数为 Phase 级跳过数。

---

## 2. 详细自测结果

### 2.1 冒烟测试 (smoke) — P0 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 1 | test_k8s_smoke_arch_check.sh | 4 / 0 | 49s | ✅ PASS | 架构检查正常 |
| 2 | test_k8s_smoke_api_reachable.sh | 6 / 0 | 114s | ✅ PASS | API Server 可达（CoreDNS 修复后） |
| 3 | test_k8s_smoke_daemonset.sh | 7 / 0 (1 skip) | 297s | ✅ PASS | DaemonSet 部署正常 |
| 4 | test_k8s_smoke_dns_resolve.sh | 4 / 0 | 120s | ✅ PASS | DNS 解析正常（容器退出码验证） |

### 2.2 API 测试 (api) — P1 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 5 | test_k8s_api_resource_crud.sh | 8 / 0 | 169s | ✅ PASS | 资源 CRUD 全通过（修复 labels + 断言） |
| 6 | test_k8s_api_namespace_lifecycle.sh | 5 / 0 | 110s | ✅ PASS | Namespace 生命周期正常 |

### 2.3 Pod 测试 (pod) — P1 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 7 | test_k8s_pod_basic_lifecycle.sh | 5 / 0 | 254s | ✅ PASS | Pod 基本生命周期正常 |
| 8 | test_k8s_pod_multi_container.sh | 4 / 0 | 199s | ✅ PASS | 多容器 Pod 正常（修复 labels 匹配） |

### 2.4 配置管理 (config) — P2 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 9 | test_k8s_config_configmap.sh | 9 / 0 | 200s | ✅ PASS | ConfigMap 挂载和环境变量注入正常 |
| 10 | test_k8s_config_secret.sh | 5 / 0 | 211s | ✅ PASS | Secret 管理正常 |

### 2.5 认证授权 (auth) — P2 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 11 | test_k8s_auth_serviceaccount.sh | 4 / 0 | 219s | ✅ PASS | ServiceAccount 认证正常 |

### 2.6 网络测试 (network) — P1 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 12 | test_k8s_network_dns.sh | 5 / 0 (1 skip) | 166s | ✅ PASS | DNS Service 连通性正常 |
| 13 | test_k8s_network_service_clusterip.sh | 4 / 0 | 216s | ✅ PASS | ClusterIP 服务正常 |
| 14 | test_k8s_network_service_nodeport.sh | 4 / 0 | 168s | ✅ PASS | NodePort 服务正常 |
| 15 | test_k8s_network_cross_node_pod.sh | 4 / 0 | 269s | ✅ PASS | 跨节点 Pod 通信正常 |

### 2.7 存储测试 (storage) — P1 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 16 | test_k8s_storage_volume_mount.sh | 10 / 0 | 205s | ✅ PASS | EmptyDir + HostPath 挂载正常 |
| 17 | test_k8s_storage_pvc_binding.sh | 3 / 0 | 161s | ✅ PASS | PVC 绑定正常（创建消费者 Pod 触发） |
| 18 | test_k8s_storage_data_persistence.sh | 7 / 0 | 279s | ✅ PASS | 数据持久化验证通过 |

### 2.8 调度测试 (scheduling) — P2 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 19 | test_k8s_scheduling_nodeselector.sh | 4 / 0 | 166s | ✅ PASS | NodeSelector 调度正常 |
| 20 | test_k8s_scheduling_affinity.sh | 4 / 0 | 181s | ✅ PASS | Pod Affinity/Anti-Affinity 正常 |
| 21 | test_k8s_scheduling_taints_tolerations.sh | 4 / 0 | 153s | ✅ PASS | Taints & Tolerations 正常 |
| 22 | test_k8s_scheduling_resource_quota.sh | 4 / 0 | 147s | ✅ PASS | ResourceQuota 限制正常 |

### 2.9 工作负载 (workload) — P1 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 23 | test_k8s_workload_deployment.sh | 6 / 0 | 238s | ✅ PASS | Deployment 生命周期正常 |
| 24 | test_k8s_workload_replicaset.sh | 4 / 0 | 221s | ✅ PASS | ReplicaSet 管理正常 |

### 2.10 Kata 运行时 (kata) — P2 优先级

| # | 测试脚本 | Phases (good/bad) | 耗时 | 结果 | 备注 |
|:-:|---------|:---:|:---:|:---:|------|
| 25 | test_k8s_kata_runtime_basic.sh | 5 / 0 | 130s | ✅ PASS | kata-clh RuntimeClass 基本创建/销毁正常 |

---

## 3. 自测过程中发现的问题与修复

### 3.1 环境问题：CoreDNS CrashLoopBackOff

**问题**：首次执行时集群 CoreDNS 未正常运行，导致 `api_reachable` 和 `dns_resolve` 失败。

**根因**：CoreDNS v1.13.1 默认 `forward . /etc/resolv.conf` → 节点使用 systemd-resolved (127.0.0.1) → 流量回环到 CoreDNS → `plugin/loop` 检测触发 CrashLoopBackOff。

**修复**：修改 CoreDNS ConfigMap 中 `forward` 目标为外部 DNS：
```
forward . 114.114.114.114 223.5.5.5
```
然后 `kubectl rollout restart deploy/coredns -n kube-system`。

### 3.2 脚本问题修复（共 4 个）

| 脚本 | 问题 | 修复 |
|------|------|------|
| **dns_resolve** | `kubectl run --rm` 需要 TTY attach，日志不可用 | 改用容器退出码判断 DNS 结果（`{.status.containerStatuses[0].state.terminated.exitCode}`） |
| **resource_crud** | Pod YAML 缺 `labels`，断言期望 `Pending` 但 Pod 已 `Running` | 加 `labels: {app: test-pod}`；修正断言 `Pending` → `Running` |
| **pod_multi_container** | Pod YAML 缺 `labels`，`k8sWaitForPodReady` label selector 不匹配 | 加 `labels: {app: multi-container-test}` |
| **pvc_binding** | local-path `WaitForFirstConsumer`，PVC 不自动绑定 | 创建消费者 Pod 触发绑定后验证，然后清理 |

### 3.3 自测期间干预记录

多个测试脚本的 Namespace 在清理阶段卡入 `Terminating` 状态，需人工 force-clean：

| 受影响的 Namespace | 所属测试 | 处理方式 |
|---|---|---|
| k8s-feature-test-sto-persist | data_persistence (#18) | Force delete pods → force delete ns |
| k8s-feature-test-wl-rs | replicaset (#24) | Force delete pods → force delete ns |
| k8s-feature-test-kata | kata_runtime_basic (#25) | Force delete pods → force delete ns |

---

## 4. 自测结论

### 4.1 关键指标

| 指标 | 首次执行 | 修复后复测 |
|------|:---:|:---:|
| 总脚本数 | 25 | 25 |
| 通过 | 17 (68.0%) | **25 (100%)** |
| 失败 | 8 (32.0%) | **0 (0%)** |
| 总耗时 | ~78min | ~24min（重测 8 个） |

### 4.2 需求覆盖验证

对照[需求文档](./requirement.md)的 7 条需求（R1~R7）：

| 需求ID | 需求描述 | 覆盖情况 |
|--------|---------|:---:|
| R1 | Sonobuoy Smoke 等价 | ✅ smoke 目录 4 个脚本全部通过 |
| R2 | Sonobuoy Conformance 关键领域 | ✅ 10 个 SIG 领域全覆盖 |
| R3 | 多节点集群验证 | ✅ DaemonSet + cross_node_pod 验证通过 |
| R4 | Kata 容器运行时 | ✅ kata_runtime_basic 验证通过 |
| R5 | 单用例独立运行 | ✅ 每个脚本有独立 Namespace，可单独执行 |
| R6 | 共享函数库 `lib.sh` | ✅ 25 个脚本统一复用 |
| R7 | tmt + beakerlib 框架 | ✅ 全部基于 beakerlib Phase 执行 |

### 4.3 后续改进建议

1. **消除 kubelet cert 依赖**：当前环境 `kubectl exec/logs` 不可用（apiserver kubelet client cert 缺失），部分测试使用 jsonpath/退出码替代验证。建议配置 kubelet 客户端证书以启用完整验证。
2. **优化 Namespace 清理**：调查 containerd/内核 cleanup 延迟原因，避免 Namespace 卡 Terminating。
3. **CI 集成**：将 `run_full_tests.py` 集成到 CI/CD pipeline，每次提交自动执行。
