#Sinatra bussiness layer

[![Build Status](https://travis-ci.org/azranel/TAS.svg?branch=master)](https://travis-ci.org/azranel/TAS) 
[![Code Climate](https://codeclimate.com/github/azranel/TAS/badges/gpa.svg)](https://codeclimate.com/github/azranel/TAS)
[![Test Coverage](https://codeclimate.com/github/azranel/TAS/badges/coverage.svg)](https://codeclimate.com/github/azranel/TAS)

##Usage

###Configuration
Of course you need to have ruby installed (google for rvm).
Go into /busslayer catalog and write in terminal

```
bundle install
rake db:create
rake db:migrate
```

If you want to have some data in database at start then:

```
rake db:seed
```

###Running
```
ruby app.rb
```

or just

```
./app.rb
```

###Console

Go into /busslayer catalog and write in terminal

```
irb
```

and then in ruby interpreter write

```ruby
require './app'
```

Now you have access to all models like

```ruby
User.all
```

will return all users from database.

```ruby
Apartment.all
```

will return all apartments from database.

###Tests

Business layer uses RSpec library for unit tests. To run test got into busslayer catalog and write:

```
bundle exec rake
```

##Distributed Ruby (dRb)

To use dRb go into terminal, run ruby interpreter and then:

```ruby
require 'drb'
DRb.start_service
obj = DRbObject.new(nil, 'druby://localhost:9000')
```

Now we have object from which we can invoke methods from RMIServer class (busslayer/rmiserv.rb file)

For example:

```ruby
obj.fetch_all_users
```

Will return JSON with data of users.
