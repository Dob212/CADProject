class UpdateUsers < ActiveRecord::Migration
  def change
  	@u = User.find_by(email: 'admin@gmail.com')
  	@u.update_attribute :admin, true
  end
end
