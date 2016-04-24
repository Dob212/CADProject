class ChangeDataTypeForFieldname < ActiveRecord::Migration
  def change
  	change_column(:events, :ecost, 'decimal USING CAST(ecost AS decimal)')
  end
end
