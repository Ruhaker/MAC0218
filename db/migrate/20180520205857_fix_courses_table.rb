class FixCoursesTable < ActiveRecord::Migration[5.1]
  def change
    rename_column :courses, :faculty, :teaching_unit
  end
end
