#Sinatra bussiness layer

##Usage

###Configuration
Of course you need to have ruby installed (google for rvm).
Go into /busslayer catalog and write in terminal

```
bundle install
rake db:create
rake db:migrate
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

##Possible problems
- Database login atm is my local PC account name. Temporary fix for this is going to config/database.yml and changing username to your account username.
