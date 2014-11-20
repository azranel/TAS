# Remote Method Invocation Server
class RMIServer
  def initialize
  end

  def add_user(params)
    User.create(params)
  end

  def fetch_all_users
    User.all.as_json
  end

  def add_apartment(params)
    Apartment.create(params)
  end

  def fetch_all_apartments
    Apartment.all.as_json
  end
end

