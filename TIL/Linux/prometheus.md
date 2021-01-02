# Prometheus Monitoring Notes

## Prometheus API Example

Get information about the current configuration

```
curl localhost:9090/api/v1/status/config
```

## Node Exporter

sudo useradd -M -r -s /bin/false node_exporter

# Querying

## Query Basics

### Selectors


Get all lablel matches

```shell
# Exact lable match
node_cpu_seconds_total{mode="user"}
# Regex lable match
node_cpu_seconds_total{mode=~"u.*"}
# Inverse Regex lable match
node_cpu_seconds_total{mode=!~"user|idle"}
```
### Range Vector Selector

```shell
# Get all timeseries for the last two minutes
node_cpu_seconds_total{mode="user"}[2m]
```

### Offset Modifier

```bash
query offset 1h

query[5m] offset 1h
```

### Query Functions

abs() - absolute values
clamp_max() - returns values but replaces them with a maximum value if they exceed that value
clamp_min() -  Returns values, but replaces them with a minimum value if they are less than that value

rate() - is a particularly useful function for tracking t he average per-second rate of increase in a time-series value.

For example, this function is useful for alerting when a particular metric "spikes", or increases abnormally quickly.

### Alertmanager Installation

```shell
sudo useradd --no-create-home --shell /bin/false alertmanager
wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
tar xfz alertmanager*
sudo mv alertmanager*/{alertmanager,amtool} /usr/local/bin/
sudo chown alertmanager:alertmanager /usr/local/bin/{alertmanager,amtool}
sudo cp alertmanager*/alertmanager.yml /etc/alertmanager/
sudo mkdir /etc/amtool/ && sudo touch /etc/amtool/config.yml


```

```
[Unit]
Description=Alertmanager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
 --config.file /etc/alertmanager/alertmanager.yml \
 --storage.path /var/lib/prometheus/

[Install]
WantedBy=multi-user.target
```

#### Alertmanager High Availability


Add the ```--cluster.peer=192.168.99.221``` option in the service or container options.
Also add every Alertmanager instance to the prometheus.yml.