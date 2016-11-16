# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

install ruby-install from here:
  https://github.com/postmodern/ruby-install

run ruby-install ruby-2.3.1

install chruby from here:
  https://github.com/postmodern/chruby

add the auto-switching for chruby

create workspace directory
in workspace directory:
run command echo "ruby-2.3.1" > .ruby-version
run gem install rails to install rails 5
run rails new smack_server --api --skip-active-record
you might need to run bundle install
