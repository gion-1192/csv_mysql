module Csv_mysql

	class Mysql_dat
		attr_accessor :client, :columns, :table

		def initialize
			@table = 'rakutens'
			@client = Mysql2::Client.new(Csv_mysql.mysql_config)
			@columns = @client.query("show columns from #{@table}")	
		end	

		def insert(file_path)
			ext = File.extname(file_path)
			file_table = Object.const_get("Csv_mysql::#{ext[1, ext.length].capitalize}_analysis").new.load_file(file_path)
			
			file_table.each_value do |keys, values|
				@client.query("insert into #{@table}(#{keys.join(",")}) values(#{values.join(",")})")
			end
		end

		def my_define_method(name)
			Mysql_dat.class_eval do
				define_method(name) do |value|
					if locate_columns?(name)
						@client.query("alter table #{@table} add column #{name}")
					end

					hash = {key => value}
				end
			end
		end
		
		private
		
		def locate_columns?(key)
			@columns.each do |col|
				return true if col["Field"] == key
			end
			return false
		end
	end
end

#mys = Mysql_dat.new

#csv_data = CSV.read('item.csv', headers: true)
#csv_data.headers.each do |header|
#	unless mys.subs(header).nil?
#		mys.my_define_method(mys.subs(header))
#	end
#end

#p mys.price
