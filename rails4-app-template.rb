git :init
git add: "."
git commit: %Q{-m 'Initial commit'}

# Ignore /vendor/
run "cat <<EOF >> .gitignore

/vendor/
EOF"
git commit: %Q{-a -m 'Add /vendor/ to .gitignore'}

# add mysql collation configs to database.yml
gsub_file 'config/database.yml',
  /^  encoding: utf8$/, "\\0\n  collation: utf8_general_ci"

# Add database.yml.base and ignore database.yml
run %Q{echo '' >> Gemfile}
run "cat <<EOF >> .gitignore
/config/database.yml
EOF"
git mv: %Q{config/database.yml config/database.yml.base}
run "cp config/database.yml.base config/database.yml"
git commit: %Q{-a -m 'Ignore database.yml'}

## Disable turbolinks
gsub_file 'Gemfile',
  /^# Turbolinks makes following links in your web application faster.*\ngem 'turbolinks'\n\n/, ''
gsub_file 'app/assets/javascripts/application.js',
  /^\/\/= require turbolinks\n/, ''
gsub_file 'app/views/layouts/application.html.erb',
  /, \"data-turbolinks-track\" => true/, ''
git commit: %Q{-a -m 'Disable turbolinks'}

# Disable assets pipeline.
# We would like to have assets tasks, so don't use --skip-sprockets 
gsub_file 'config/application.rb',
  /^  end$/, "\n    config.assets.enabled = false\n\\0"
git commit: %Q{-a -m 'Disable asset pipelines, but leave asset tasks.'}

# bundle install
run "bundle install --path vendor/bundle"
git add: "Gemfile.lock"
git commit: %Q{-m 'Commit Gemfile.lock'}
