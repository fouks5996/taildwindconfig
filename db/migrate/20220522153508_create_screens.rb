class CreateScreens < ActiveRecord::Migration[5.2]
  def change
    create_table :screens do |t|
      t.string :name
      t.string :value
      t.belongs_to :project
      t.timestamps
    end
  end
end
