class CreateAlumnos < ActiveRecord::Migration[8.0]
  def change
    create_table :alumnos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
