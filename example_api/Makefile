default: build

build: config
    docker-compose build

start: setup
  docker-compose up

db-setup:
  docker-compose run web bundle exec rake db:setup --trace

compose-run:
  docker-compose up --build -d
  sleep 20

tests:
  docker-compose run web bundle exec rake spec
