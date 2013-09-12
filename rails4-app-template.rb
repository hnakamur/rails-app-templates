git :init
git add: "."
git commit: %Q{-m 'Initial commit'}

# Ignore /vendor/
run "cat <<EOF >> .gitignore

/vendor/
EOF"
git commit: %Q{-a -m 'Add /vendor/ to .gitignore'}

# Add mysql2 gem
gem 'mysql2'
run %Q{echo '' >> Gemfile}
git commit: %Q{-a -m 'Add mysql2 gem'}

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

# bundle install
run "bundle install --path vendor/bundle"

# This does not work since it runs before bundle install.
# Please commit by hand.
#git commit: %Q{-a -m 'Commit Gemfile.lock'}
