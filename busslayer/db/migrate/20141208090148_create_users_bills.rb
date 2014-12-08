class CreateUsersBills < ActiveRecord::Migration
  def change
    create_table :users_bills do |t|
      t.belongs_to :user
      t.belongs_to :bill
      t.timestamps
    end
  end
end
