class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.string :name
      t.string :description
      t.float :value
      t.belongs_to :apartment
      t.belongs_to :user, :as => :owner

      t.timestamps
    end
  end
end
