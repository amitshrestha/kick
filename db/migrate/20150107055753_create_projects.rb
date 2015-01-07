class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.text :abstract
      t.float :budget

      t.timestamps
    end
  end
end
