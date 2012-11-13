require 'bundler'
Bundler.require
require 'pry'

ActiveRecord::Base.establish_connection(YAML.load_file('./database.yml'))
require './domain'

query = "SELECT {[Measures].[Balance]} ON COLUMNS, {[Customers].children} ON ROWS FROM [CubeAccountSnapshots] WHERE ([Date].[2012].[4])"

cas = CubeAccountSnapshot.last

binding.pry

cas.mdx query
