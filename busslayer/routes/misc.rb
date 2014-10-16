module Sinatra
  module SampleApp
    module Routing
      module Misc
        def self.registered(app)
          app.not_found do
            content_type :json
            { status: 404 }.to_json
          end
        end
      end
    end
  end
end
