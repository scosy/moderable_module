class AddIsAcceptedColumnToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :is_accepted, :boolean, default: true
  end
end
