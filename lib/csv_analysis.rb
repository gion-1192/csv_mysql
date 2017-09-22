module Csv_mysql
	class Csv_analysis < Analysis
		def load_file(file_path)
			csv_data = CSV.read(file_path, headers: true)
			table = Sql_table.new
			csv_data.each do |row|
				table.set_data(row)
			end

			return table
		end
	end
end
