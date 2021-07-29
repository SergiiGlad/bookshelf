#! /bin/bash
# Copyright 2015 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [START startup]
set -v

# Talk to the metadata server to get the project id
PROJECTID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")

# Install logging monitor. The monitor will automatically pickup logs sent to
# syslog.
# [START logging]
curl -s "https://storage.googleapis.com/signals-agents/logging/google-fluentd-install.sh" | bash
service google-fluentd restart &
# [END logging]

# Install dependencies from apt
apt-get update
apt-get install -yq git supervisor python python-pip

# pip from apt is out of date, so make it update itself and install virtualenv.
pip install --upgrade pip virtualenv

# Create a pythonapp user. The application will run as this user.
useradd -m -d /home/pythonapp pythonapp

# Set ownership to newly created account
chown -R pythonapp:pythonapp /opt/app

# Get the source code from the Google Cloud Repository
# git requires $HOME and it's not set during the startup script.
export HOME=/root
git config --global credential.helper gcloud.sh
git clone https://source.developers.google.com/p/$PROJECTID/r/bookshelf /opt/app

# Install app dependencies
virtualenv -p python3 /opt/app/7-gce/env
source /opt/app/7-gce/env/bin/activate
/opt/app/7-gce/env/bin/pip install -r /opt/app/7-gce/requirements.txt

# Install and run cloud-sql-proxy as unit service 
wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /usr/local/bin/cloud_sql_proxy
chmod +x /usr/local/bin/cloud_sql_proxy
mkdir /var/run/cloud-sql-proxy
mkdir /var/local/cloud-sql-proxy
cp /opt/app/7-gce/gce/linux_conf/cloud-sql-proxy.service /lib/systemd/system/cloud-sql-proxy.service
systemctl daemon-reload
systemctl enable cloud-sql-proxy
systemctl start cloud-sql-proxy

# Put supervisor configuration in proper place
cp /opt/app/7-gce/gce/linux_conf/python-app.conf /etc/supervisor/conf.d/python-app.conf

# Start service via supervisorctl
supervisorctl reread
supervisorctl update

# Application should now be running under supervisor
# [END startup]
