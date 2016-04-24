class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def change
  	change_column(:events, :ecost, :decimal)
  end
end
