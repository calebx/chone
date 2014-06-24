class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.references :item, index: true
      
      t.integer    :status
      t.integer    :sum
      t.string     :code    # 统计标签
      t.text       :content

      t.timestamps
    end
  end
end
