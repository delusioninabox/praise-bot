class AddTeamTeamIdToViews < ActiveRecord::Migration[5.2]
  def change
    add_column :views, :team_id, :string
  end
end
