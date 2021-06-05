class ManyToManyUserDepartment < ActiveRecord::Migration[6.1]
  def change
    create_table :departments_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :department
    end
  end
end
