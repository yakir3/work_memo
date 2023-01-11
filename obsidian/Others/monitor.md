#### 指标 Metrics -> Prometheus

+ kubelet 内置 cAdvisor：容器内部内存、CPU、网络、文件系统指标

+ 节点指标 node_exporter：节点级别

+ 组件指标：
  resource metrics：metrics-server 透出
  custom metrics：自定义 

#### 日志 Logging

+ 收集类型

内核日志
runtime 日志
组件日志
应用日志

+ 采集方式

主动：业务直推、dockerengine 推送

被动：Daemonset、sidercar 

#### Event 事件

k8s-eventer 收集 event 事件

#### 链路追踪

# 
