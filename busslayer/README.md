#Sinatra bussiness layer

##Usage
Of course you need to have ruby installed (google for rvm).
Go into /busslayer catalog and write in terminal

```
rake db:create
rake db:migrate
ruby app.rb
```

##Possible problems
- Database login atm is my local PC account name. Temporary fix for this is going to config/database.yml and changing username to your account username.
