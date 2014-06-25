class AddOnSaleDateToItems < ActiveRecord::Migration
  def change
    add_column :items, :on_sale_date, :date
    add_column :items, :off_sale_date, :date
  end
end
