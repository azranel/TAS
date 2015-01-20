class CreateMessages < ActiveRecord::Migration
  def change
  	create_table :messages do |t|
  		t.string :subject
  		t.text :content
        t.belongs_to :user
        t.belongs_to :apartment
        t.timestamps
  	end
  end
end
