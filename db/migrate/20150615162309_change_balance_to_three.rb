class ChangeBalanceToThree < ActiveRecord::Migration
  def change
  	change_column :users, :balance, :integer, :default => 3
  end
end
