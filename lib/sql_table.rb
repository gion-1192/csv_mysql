module Csv_mysql
	class Sql_table

		def initialize
			@len = 0
			@table = {}
		end

		def set_data(data_list)
			data_list.each do |key, value|
				@table[key] = [] if @table[key].nil?
				@table[key].push(value)						
			end
			@len += 1	
		end

		def each_value
			i = 0
			
			while(i < @len) do
				keys = []
				values = []
				
				@table.each do |key, value|
					unless Subs.conversion(key).nil? then
						keys.push(Subs.conversion(key))
						values.push("\'#{value[i]}\'")
					end
				end

				yield keys, values if block_given?

				i += 1
			end
		end
	end
end
