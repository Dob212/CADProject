class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :ename
      t.string :edescription
      t.string :etime
      t.string :ecost

      t.timestamps null: false
    end
  end
end
