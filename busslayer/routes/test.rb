module Sinatra
  module SampleApp
    module Routing
      module Test
        def self.registered(app)
          app.get  '/' do
            session[:u_id] ||= 1234
            redirect to('/foo')
          end
          app.get "/foo" do
            session[:u_id].to_s
          end
        end
      end
    end
  end
end
