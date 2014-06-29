class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.references :item, index: true
      
      t.integer    :sum
      t.integer    :category
      t.integer    :status
      t.text       :content

      t.timestamps
    end
  end
end
