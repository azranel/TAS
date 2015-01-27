module Sinatra
	module Routing
	#Contains HTTP paths for messages
		module Messages
			def self.registered(app)
				fetch(app)
				create(app)
				update(app)
				delete(app)
			end

			def self.fetch(app)
				app.get '/message/:id' do
					content_type :json
					message = Message.find_by_id(params[:id])
					if message
						message.to_json
						#hash = { status: 200, subject: message.subject, content: message.content, user_id: user_id, apartment_id: apartment_id }.to_json
					else
						{ status: 404 }.to_json
					end
				end
			end

			def self.create(app)
				app.post "/message/create" do
					content_type :json
					puts '', params.to_s, ''
					message = Message.new(params[:message])
					if message.valid?
						message.save
						h = message.fetch_hash(201, [:id])
					else
						h = message.fetch_hash(404)
					end
					h.to_json
				end	
			end

			def self.update(app)
				app.post "/message/:id/edit" do 
					content_type :json
					message = Message.find_by_id(params[:id])
					if message
						if message.update(params[:message])
							{ status: 200, apartment_id: message.apartment_id, updated_at: message.updated_at }.to_json
						else
							{ status: 403 }.to_json
						end
					else
						{ status: 404 }.to_json
					end
				end
			end

			def self.delete(app)
				app.delete "/message/:id/delete" do
					content_type :json
					message = Message.find_by_id(params[:id])
					if message
						{ status: 200, apartment_id: message.apartment_id }.to_json if message.delete
					else
						{ status: 404 }.to_json
					end
				end
			end
		end
	end
end
