class AddCustomValuesToViews < ActiveRecord::Migration[5.2]
  def change
    add_column :views, :custom_values, :string
  end
end
