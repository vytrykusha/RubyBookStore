#!/usr/bin/env bash
# Install dependencies
bundle install

# Precompile assets
bundle exec rails assets:precompile

# Prepare DB
bundle exec rails db:setup
