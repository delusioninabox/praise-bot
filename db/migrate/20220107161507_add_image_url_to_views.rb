class AddImageUrlToViews < ActiveRecord::Migration[5.2]
  def change
    add_column :views, :image_url, :string
  end
end
