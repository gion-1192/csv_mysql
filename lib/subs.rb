module Csv_mysql
	module Subs
		class << self
			def conversion(key)
				return subs[key]
			end

			private

			def subs
				@subs ||= Proc.new {
					tmp = {}
					File.open('./config/conversion.txt') do |f|
						f.each_line do |line|
							param = line.chomp.split(",")
							tmp.store(param[0], param[1])		
						end
					end

					tmp
				}.call
			end	
		end
	end
end
