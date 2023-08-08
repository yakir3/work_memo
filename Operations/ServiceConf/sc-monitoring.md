#### Prometheus
##### main config
/opt/prometheus/prometheus.yml
```shell
# Global config
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  scrape_timeout: 10s

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets: ["alertmanager:9093"]

# Rule files
rule_files:
  # - /etc/config/rules/*.rules
  - "alerting.rules"
  - "recording.rules"

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "example-random"
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:8080', 'localhost:8081']
        labels:
          group: 'production'
      - targets: ['localhost:8082']
        labels:
          group: 'canary'

# remote_write:
#   - url: "http://localhost:9094/api/v1/read"
# remote_read:
#   - url: "http://localhost:9094/api/v1/read"

# tls_server_config:
#   cert_file: <filename>
#   key_file: <filename>
```


##### rule files
/opt/prometheus/alerting.rules
```shell
# alerting rules file
groups:
- name: alerting.rules
  rules:
  # Alert for any instance that is unreachable for >5 minutes.
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."

  # Alert for any instance that has a median request latency >1s.
  - alert: APIHighRequestLatency
    expr: api_http_request_latencies_second{quantile="0.5"} > 1
    for: 10m
    annotations:
      summary: "High request latency on {{ $labels.instance }}"
      description: "{{ $labels.instance }} has a median request latency above 1s (current value: {{ $value }}s)"
```

/opt/prometheus/recording.rules
```shell
# recoding rules file
groups:
- name: recording.rules
  rules:
  - record: code:prometheus_http_requests_total:sum
    expr: sum by (code) (prometheus_http_requests_total)
- name: rpc_random
  rules:
  - record: job_service:rpc_durations_seconds_count:avg_rate5m
    expr: avg(rate(rpc_durations_seconds_count[5m])) by (job, service)

```

> // Syntax-checking rules
> ./promtool check rules alerting.rules.yml recording.rules.yml


#### Alertmanager
/opt/prometheus/alertmanager/alertmanager.yml
```shell
global:
  resolve_timeout: 5m
route:
  group_by: ['cluster', 'alertname']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 1h
  receiver: 'default-receiver'
  routes:
    - receiver: 'database-pager'
      group_wait: 10s
      matchers:
      - service=~"mysql|cassandra"
receivers:
  - name: 'default-receiver'
    webhook_configs:
      - url: 'http://127.0.0.1:5001/'
templates:
  - /etc/alertmanager/config/*.tmpl

```


#### Grafana
/etc/grafana/grafana.ini
```shell
...

```
