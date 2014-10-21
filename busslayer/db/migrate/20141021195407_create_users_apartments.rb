class CreateUsersApartments < ActiveRecord::Migration
  def change
    create_table :users_apartments do |t|
      t.belongs_to :user
      t.belongs_to :apartment
      t.timestamps
    end
  end
end
