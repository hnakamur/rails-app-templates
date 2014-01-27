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

# Disable turbolinks
run %Q{sed -i '' -e '
/^# Turbolinks makes following links in your web application faster. Read more: https:\\/\\/github.com\\/rails\\/turbolinks/,/^$/d
' Gemfile}
run %Q{sed -i '' -e '
/^\\/\\/= require turbolinks/d
' app/assets/javascripts/application.js}
run %Q{sed -i '' -e '
s/, \"data-turbolinks-track\" => true//
' app/views/layouts/application.html.erb}
git commit: %Q{-a -m 'Disable turbolinks'}

# Disable assets pipeline.
# We would like to have assets tasks, so don't use --skip-sprockets 
run %Q{sed -i '' -e '
/^  end$/i\\
\\
\\    # Disable the asset pipeline.\\
\\    config.assets.enabled = false
' config/application.rb}
git commit: %Q{-a -m 'Disable asset pipelines, but leave asset tasks.'}

# bundle install
run "bundle install --path vendor/bundle"
git add: "Gemfile.lock"
git commit: %Q{-m 'Commit Gemfile.lock'}
