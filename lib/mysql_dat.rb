module Csv_mysql
	class Mysql_dat
		attr_accessor :client, :columns, :table

		def initialize
			@table = 'rakutens'
			@client = Mysql2::Client.new(Csv_mysql.mysql_config)
			@columns = @client.query("show columns from #{@table}")	
		end	

		def insert(file_path)
			get_sql_table(file_path).get_rows_value do |keys, values|
				begin
					keys.each do |key|
						@client.query("alter table #{@table} add column #{key}") unless locate_columns?(key)
					end
					@client.query("insert into #{@table}(#{keys.join(",")}) values(#{values.join(",")})")
				rescue => e
					Csv_mysql.write_error_log(e.message)
				end
			end
		end	

		def update(file_path)
			get_sql_table(file_path).get_rows_value do |keys, values|			
				i = 0
				tmp = []

				begin
					while(i < keys.length)
						unless keys[i] == "item_number"
							tmp.push("#{keys[i]}=#{values[i]}")
						else
							where = "item_number=#{values[i]}"	
						end
						i += 1
					end
					
					raise "No item_number" if where.nil?
					
					@client.query("update #{@table} set #{tmp.join(",")} where #{where}")
				rescue => e
					Csv_mysql.write_error_log(e.message)
				end
			end
		end
	
		private
		
		def get_sql_table(file_path)
			ext = File.extname(file_path)
			Object.const_get("Csv_mysql::#{ext[1, ext.length].capitalize}_analysis").new.load_file(file_path)
		end

		def locate_columns?(key)
			@columns.each do |col|
				return true if col["Field"] == key
			end
			return false
		end
	end
end
