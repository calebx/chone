class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :uri
      
      t.string :name
      t.string :code
      t.decimal :price
      t.string :image_uri

      t.timestamps
    end
  end
end
