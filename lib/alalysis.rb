module Csv_mysql
	class Analysis
		
		def sql_values
			@sql_values ||= {}
		end

		def load_file(file_path)
			file = File.open(file_path) do |f|			
				f
			end
		end

	end
end
