# !/bin/bash

# ssh into server
# add this to root directory
# try it and see whether it makes a deployment?

git clone https://github.com/ctoec/care-4-kids-auto-notifier.git /tmp/care-4-kids-auto-notifier
cp /home/rails/railsapps/care-4-kids-auto-notifier/shared/.env /tmp/care-4-kids-auto-notifier/.env
cd /tmp/care-4-kids-auto-notifier
bundle install
source .env
RAILS_ENV=production cap production deploy --trace