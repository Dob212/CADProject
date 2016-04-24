class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :oname
      t.string :odescription
      t.string :otime
      t.decimal :ocost
      t.references :profile, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
