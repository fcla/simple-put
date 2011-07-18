# -*- mode:ruby; -*-

require 'rubygems'
require 'railsless-deploy'

set :scm,          "git"
set :repository,   "git://github.com/daitss/simple-put.git"
set :branch,       "master"

set :use_sudo,     false
set :user,         "fischer"
set :group,        "fischer" 

set :keep_releases, 5   # default is 5

def usage(*messages)
  STDERR.puts "Usage: cap deploy -S target=<host:/file/system>"  
  STDERR.puts messages.join("\n")
  STDERR.puts "You may set the remote user and group by using -S who=<user:group> (defaults to #{user}:#{group})."
  STDERR.puts "If you set the user, you must be able to ssh to the domain as that user."
  STDERR.puts "You may set the branch in a similar manner: -S branch=<branch name> (defaults to #{variables[:branch]})."
  exit
end

usage('The deployment target was not set (e.g., target=ripple.fcla.edu:/opt/web-services/sites/silos).') unless (variables[:target] and variables[:target] =~ %r{.*:.*})

_domain, _filesystem = variables[:target].split(':', 2)

set :deploy_to,  _filesystem
set :domain,     _domain

if (variables[:who] and variables[:who] =~ %r{.*:.*})
  _user, _group = variables[:who].split(':', 2)
  set :user, _user
  set :group, _group
end

role :app, domain

after "deploy:update", "deploy:cleanup"


