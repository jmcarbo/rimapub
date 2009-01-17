require 'rubygems'
require 'pp'
require 'exifr'


module Rimapub

CONFIG_TEMPLATE = <<-END
services:
    gmail:
        type: email
        server: smtp.gmail.com
        port: 587
        hello_domain: gmail.com
        user: user
        password: password
        auth_type: plain
        source_address: user@gmail.com
        destination_address: user@gmail.com

   shutterchance:
        type: shutterchance
        login_url: http://user.shutterchance.com
        user: usero@email
        password: password

    aminus3:
        type: aminus3
        login_url: http://user.aminus3.com/admin/signin/
        user: user@email
        password: password
sets:
    default: gmail, pepet
END

	class Rimapub

		def initialize(verbose=false,config_file_name=File.expand_path('~/.rimapub/rimapub.yml'))
			@services = Hash.new
			@sets = Hash.new
			@verbose = verbose
			@publications = []
			get_config(config_file_name)
		end
		
		def verbose=(bool_value)
			@verbose=bool_value
		end
		
		def get_config(file)
			if !File.exists?(file)
				File.open(file,"w") do |f|
					f.write(CONFIG_TEMPLATE)
				end
			end

	    aConfig = YAML::load_file(file)

			aConfig['services'].each do |service_name,value|
				register_service(service_name, value)
			end
			
			aConfig['sets'].each do |set_name,value|
				register_set(set_name,value)
			end
	
			aConfig
	  end
		
		def register_service(service_name, aService)
			case aService['type']
				when 'email':
					@services[ service_name ] = RimapubServiceEmail.new(aService)
				when 'shutterchance':
					@services[ service_name ] = RimapubServiceShutterchance.new(aService)					
				when 'aminus3'
					@services[ service_name ] = RimapubServiceAminus3.new(aService)										
				else
					raise "Unimplemented service #{aService['type']}"
			end
		end
		
		def register_set(set_name, aSet)
			aSetList = aSet.split(/ *, */)
			current_set = []
			aSetList.each do |service|
				raise "service #{service} not defined in config file" if !@services[service]
				current_set << @services[service]
			end
			@sets[set_name] = current_set
			#pp @sets[set_name] if @verbose
		end
		
		def publish(image_file_name, set="default", title="", message_body="", tags="", target_date = Time.now.strftime("%Y-%m-%d"))
			raise "File #{image_file_name} does not exist" if !File.exists?(File.expand_path(image_file_name))
			raise "Set #{set} not defined in #{pp @sets}" if !@sets[set]
			
			@sets[set].each do |definition|
				puts "Publishing #{image_file_name} to #{set}" if @verbose
				if(['.jpg','.jpeg'].include? File.extname(File.expand_path(image_file_name)).downcase)
					jpeg = EXIFR::JPEG.new(File.expand_path(image_file_name))
					if jpeg.exif?
						aInfo = jpeg.exif.to_hash
						
					  title = aInfo[:artist] if aInfo[:artist] 
						message_body = aInfo[:image_description] if aInfo[:image_description]

					end
				end
				definition.publish(image_file_name, title, message_body, tags)
			end
			@publications << { :image => image_file_name, :set => set, :date => Time.now } 
		end
	end
end