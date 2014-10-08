module Sinatra
  module SampleApp
    module Routing
      module Test
        def self.registered(app)
          app.get  '/' do
            "LOL"
          end
        end
      end
    end
  end
end
