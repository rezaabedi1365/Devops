
### Add Repo
```
sudo apt-get install apt-transport-https

curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update
```
### Install
etc/filebeat/filebeat.yml
```
sudo apt-get install filebeat
sudo apt-get install metricbeat
sudo apt-get install auditbeat
sudo apt-get install packetbeat
sudo apt-get install heartbeat-elastic
```
