module Csv_mysql
	class My_client < Mysql2::Client
		def query(sql)
			super(escape(sql))
		end
	end
end
