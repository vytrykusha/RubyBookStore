# frozen_string_literal: true

# Seed editable pages for about and home
EditablePage.find_or_create_by!(slug: 'about') do |page|
  page.content = File.read(Rails.root.join('app/views/pages/about.html.erb'))
end
EditablePage.find_or_create_by!(slug: 'home') do |page|
  page.content = File.read(Rails.root.join('app/views/home/index.html.erb'))
end
