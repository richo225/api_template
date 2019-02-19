# frozen_string_literal: true

insert_into_file '.gitignore', '/config/credentials.yml.enc'

git :init
git add: "."
git commit: "-m 'Initial commit'"
