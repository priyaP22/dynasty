class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :type, null: :false
      t.integer :mother_id
      t.integer :father_id
      t.integer :spouse_id
      t.timestamps
    end
  end
end
