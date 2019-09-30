#!/bin/bash

# rm -rf /tmp/care-4-kids-auto-notifier
# mkdir /tmp/care-4-kids-auto-notifier
# cp -r ~/Code/care-4-kids-auto-notifier /tmp/care-4-kids-auto-notifier
# git clone https://github.com/ctoec/care-4-kids-auto-notifier.git /tmp/care-4-kids-auto-notifier
# cp /home/rails/railsapps/care-4-kids-auto-notifier/shared/.env /tmp/care-4-kids-auto-notifier/.env
# cp /home/melanie/Code/care-4-kids-auto-notifier/.env /tmp/care-4-kids-auto-notifier/.env
# cd /tmp/care-4-kids-auto-notifier
# source .env


sudo docker-compose up -d --build
sudo docker-compose exec app bash
RAILS_ENV=production cap development deploy --trace
# cd ~/Code/care-4-kids-auto-notifier