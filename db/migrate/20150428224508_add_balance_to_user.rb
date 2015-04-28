class AddBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :balance, :integer, :default => 1
  end
end
