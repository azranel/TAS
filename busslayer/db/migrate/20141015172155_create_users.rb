class CreateUsers < ActiveRecord::Migration
    def change
    create_table :users do |t|
        t.string :name
        t.string :lastname
        t.string :email
        t.string :password
        t.string :phone
        t.timestamps
    end
end
