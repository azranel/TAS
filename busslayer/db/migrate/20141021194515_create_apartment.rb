class CreateApartment < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.string :name
      t.string :address
      t.string :city
      t.belongs_to :user
      t.text :description
      t.timestamps
    end
  end
end
