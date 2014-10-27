module Sinatra
  module Routing
    module Misc
      def self.registered(app)
        app.not_found do
          content_type :json
          { status: 404, message: "Site not found" }.to_json
        end
      end
    end
  end
end
