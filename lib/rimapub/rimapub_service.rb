require 'net/smtp'
require 'tlsmail'
require 'tmail'
require 'base64'
require 'rubygems'
require 'mechanize'


module Rimapub
	class RimapubService
		def initialize
			
		end
	end
	
	class RimapubServiceAminus3 < RimapubService

		def initialize(service_config)
			@user = service_config['user']
			@password = service_config['password']
			@login_url = service_config['login_url']
		end
		
		def publish(image_file, title=nil, message_body="", tags="", target_date = Time.now.strftime("%Y-%m-%d"))
			 agent = WWW::Mechanize.new
			 page = agent.get(@login_url)
			 aminus_form = page.forms[0]

			 aminus_form.email = @user
			 aminus_form.password = @password
			 page = agent.submit(aminus_form)

			 page = agent.click page.link_with(:text=>"upload new images")

			 aminus_form = page.forms[0]
			 aminus_form.field_with(:name => 'category_id').options[6].select
			 aminus_form.field_with(:name => 'caption').value = message_body
			 aminus_form.field_with(:name => 'name').value = title
			 aminus_form.date = target_date

			 aDate = target_date.split(/\-/)
			 aminus_form.field_with(:name => 'day').options[aDate[2].to_i - 1].select
			 aminus_form.field_with(:name => 'month').options[aDate[1].to_i - 1].select
			#TODO 
			 aminus_form.field_with(:name => 'year').options[5].select
			
			 aminus_form.file_uploads.first.file_name = image_file
			 page = agent.submit(aminus_form, aminus_form.buttons[0])


		end
	end
	
	
	class RimapubServiceShutterchance < RimapubService

		def initialize(service_config)
			@user = service_config['user']
			@password = service_config['password']
			@login_url = service_config['login_url']
		end
		
		def publish(image_file, title=nil, message_body="", tags="", target_date = Time.now.strftime("%Y-%m-%d"))
			agent = WWW::Mechanize.new
			page = agent.get(@login_url)
 
		  sc_form = page.forms[3]

		  sc_form.username = @user
		  sc_form.password = @password
		  page = agent.submit(sc_form, sc_form.buttons[0])
			

  		sc_form = page.forms[3]

	  	sc_form.file_uploads.first.file_name = image_file
		  page = agent.submit(sc_form, sc_form.buttons[0])
 
  		sc_form = page.forms[6]
	  	sc_form.add_field!('dataArea0', target_date)
		  sc_form.add_field!('title', title)
		  page = agent.submit(sc_form)
		end
	end
	
	class RimapubServiceEmail < RimapubService
		
		def initialize(server, port, hello_domain, user, password, auth_type, source_address, destination_address)
			@server = server
			@port = port
			@hello_domain = hello
			@user = user
			@password = password
			@auth_type = auth_type
			@source_address = source_address
			@destination_address = destination_address
		end
		
		def initialize(service_config)
			@server = service_config['server']
			@port = service_config['port']
			@hello_domain = service_config['hello']
			@user = service_config['user']
			@password = service_config['password']
			@auth_type = service_config['auth_type']
			@source_address = service_config['source_address']
			@destination_address = service_config['destination_address']
		end
		
		def publish(image_file, title=nil, message_body="", tags="")
				raise "No file exception" if !FileTest.exists?(File.expand_path(image_file))
					
				title = image_file if !title
				
			  mail = TMail::Mail.new
			  mail.to = @destination_address
			  mail.from = @source_address
			  mail.subject = title
			  mail.date = Time.now
			  mail.mime_version = '1.0'

				mailpart1=TMail::Mail.new
				mailpart1.set_content_type 'text', 'plain'
				mailpart1.body = message_body + "\n\nTAGS:\n" + tags
				mail.parts << mailpart1
				mail.set_content_type 'multipart', 'mixed'				

				content=IO::readlines(File.expand_path(image_file), nil)
				mailpart=TMail::Mail.new
				mailpart.body = Base64.encode64(content.to_s)
				mailpart.transfer_encoding="Base64"
				mailpart['Content-Disposition'] = "attachment; filename=#{File.basename(image_file)}"
				image_class = "jpeg"
				case File.extname(image_file).downcase
					when 'jpg'
						image_class = "jpeg"
				end
				mailpart['Content-Type'] = "image/#{image_class}; name=#{File.basename(image_file)}"
				
				mail.parts.push(mailpart)


				Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
				Net::SMTP.start(@server, @port, @hello_domain,
			                    @user, @password, @auth_type) do |smtp|
														smtp.send_message mail.to_s, @source_address, @destination_address
				end
		end
	end
end