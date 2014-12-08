users = [
  { firstname: 'Arkadiusz', lastname: 'Nowak', email: 'areno@o2.pl', password: 'alamakota', phone: '624563902'},
  { firstname: 'Karolina', lastname: 'Kowalik', email: 'karko@wp.pl', password: 'alamakota', phone: '624564183'},
  { firstname: 'Bartosz', lastname: 'Łęcki', email: 'bartel@gmail.com', password: 'alamakota', phone: '667894532'},
  { firstname: 'Adam', lastname: 'Kowalski', email: 'adako@hotmail.com', password: 'alamakota', phone: '785934024'},
  { firstname: 'Ireneusz', lastname: 'Bukowiecki', email: 'irebu@wp.pl', password: 'alamakota', phone: '667123456'},
]

apartments = [
  { name: 'Narnia', description: 'Domek z bramą', address: 'Gromadzka 25b', city: 'Poznań', user_id: 1 },
  { name: 'Róża', description: 'Bogactwo', address: 'Drewsa 25', city: 'Poznań', user_id: 2 },
]

bills = [
  { name: 'Papier', description: 'szary', value: '4.99', apartment_id: 0, user_id: 1 },
  { name: 'Garnki', description: 'czerwony', value: '44.99', apartment_id: 1, user_id: 2 },
]

users.each do |user|
  User.create(user)
end

apartments.each do |apartment|
  Apartment.create(apartment)
end

User.all.each do |user|
  Apartment.first.users << user
end

bills.each do |bill|
  Bill.create(bill)
end