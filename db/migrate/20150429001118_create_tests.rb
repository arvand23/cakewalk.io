class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.integer :user_id
      t.string :url
      t.string :cwurl
      t.datetime :complete_date

      t.timestamps
    end
  end
end
