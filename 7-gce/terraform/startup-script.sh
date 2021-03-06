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

# Install dependencies from apt
apt-get update
apt-get install git python-pip gunicorn -yq

# Install Ansible
pip install ansible
 
# Get the source code from the Google Cloud Repository
# git requires $HOME and it's not set during the startup script.
export HOME=/root
git config --global credential.helper gcloud.sh
#git clone https://source.developers.google.com/p/$PROJECTID/r/bookshelf /opt/app
git clone https://github.com/SergiiGlad/bookshelf.git /opt/app

# Run ansible playbook
ansible-playbook /opt/app/7-gce/ansible/bookshelf-playbook.yaml
