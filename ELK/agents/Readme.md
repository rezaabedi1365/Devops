
### add repo
```
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list

# آپدیت پکیج‌ها
sudo apt-get update
```
### install
etc/filebeat/filebeat.yml
```
sudo apt-get install filebeat
sudo apt-get install metricbeat
sudo apt-get install auditbeat
sudo apt-get install packetbeat
sudo apt-get install heartbeat-elastic
```
