require 'bundler/setup'
Bundler.require
DB = {conn: SQLite3::Database.new("yelper.db")}

require_all 'app'