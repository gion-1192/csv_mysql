require 'mysql2'
require 'csv'
require 'yaml'

require './lib/mysql_dat'
require './lib/my_client'
require './lib/subs'
require './lib/analysis'
require './lib/csv_analysis'
require "./lib/sql_table"

module Csv_mysql
	class << self
		def mysql_config
			@my_config ||= YAML.load_file("./config/database.yml")
		end

		def mysql_dat
			Mysql_dat.new
		end

		def write_error_log(log)
			File.open("./config/error_log.txt", "a") do |f|
				f.puts(log)
			end
		end
	end
end

Csv_mysql.mysql_dat.update("./csv/item.csv")
