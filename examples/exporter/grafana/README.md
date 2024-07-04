# OpenTelemetry with Grafana

Based on [video course](https://www.udemy.com/course/mastering-prometheus-and-grafana/learn/lecture/27491608?start=0#overview) on <udemy.com>.

## Components

- **Data store**
  - Prometheus
  - Alloy
  - Grafana Loki
- **OpenTelemetry**
  - Collector (Grafana Alloy)
  - API
  - Autoinstumentation
  - SDK
- **Prometheus**
  - Prometheus
  - Alertmanager
  - Prometheus to Teams Connector
  - Pushgateway
- **Visualisation**
  - Grafana

## Prerequirements

- Docker
- Docker Compose
- Microservice architechture
- Distributed Tracing
- C#

## Steps

1. Start all components `docker compose up -d`
2. Open Node-Exporter <http://localhost:9100>
3. Open Prometheus <http://localhost:9090>
4. Open Grafana on <http://localhost:3000>
5. Open Grafana Alloy <http://localhost:12345>

## Metrics

As an example we collect following metrics:

- CPU Usage  
- Memory Usage
- Disk Usage
- Network Usage
- HTTP Requests

In Prometheus this metrics equivalent to:

| Metric | Description |
| ------ | ----------- |
| `node_load15` | CPU 15m load average |
| `node_memory_MemFree_bytes` | Total free memory in bytes. |
| `node_filesystem_avail_bytes` | Free disk space in bytes. |
| `node_network_receive_bytes_total` | Total number of bytes received. |
| `node_network_transmit_bytes_total` | Total number of bytes transmitted. |

### Prometheus queries

- CPU Usage: `100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
- Memory Usage: `node_memory_MemFree_bytes / node_memory_MemTotal_bytes * 100`
- Disk Usage: `node_filesystem_avail_bytes / node_filesystem_size_bytes * 100`
- Network Usage: `sum(node_network_receive_bytes_total) / sum(node_network_transmit_bytes_total) * 100`
- HTTP Requests: `sum(rate(node_network_receive_bytes_total{job=~"node-.*"}[5m]))`

➡ [Prometheus example board](http://localhost:9090/graph?g0.expr=sum(node_memory_Active_bytes%7Bjob%3D%22node-orbstack%22%7D)&g0.tab=0&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=1h&g1.expr=node_network_transmit_bytes_total&g1.tab=0&g1.display_mode=lines&g1.show_exemplars=0&g1.range_input=1h&g2.expr=node_memory_MemFree_bytes&g2.tab=0&g2.display_mode=lines&g2.show_exemplars=0&g2.range_input=1h&g3.expr=node_load15&g3.tab=0&g3.display_mode=lines&g3.show_exemplars=0&g3.range_input=1h&g4.expr=avg(node_filesystem_avail_bytes%20)%20by%20(device)&g4.tab=0&g4.display_mode=lines&g4.show_exemplars=0&g4.range_input=1h&g5.expr=node_network_receive_bytes_total%7Bdevice%3D%22eth0%22%7D&g5.tab=1&g5.display_mode=stacked&g5.show_exemplars=0&g5.range_input=1h&g6.expr=100%20-%20(avg%20by%20(instance)%20(irate(node_cpu_seconds_total%7Bmode%3D%22idle%22%7D%5B5m%5D))%20*%20100)&g6.tab=0&g6.display_mode=lines&g6.show_exemplars=0&g6.range_input=1h&g7.expr=avg(prometheus_http_requests_total)%20by%20(code)&g7.tab=0&g7.display_mode=lines&g7.show_exemplars=0&g7.range_input=1h)

## Rules

### Alerts

Take a look to <https://samber.github.io/awesome-prometheus-alerts/rules> to get inspired for your
own rules.

- CPU Usage > 80%
- Memory Usage > 80%
- Disk Usage > 80%
- Network Usage > 80%
- HTTP Requests > 8000
