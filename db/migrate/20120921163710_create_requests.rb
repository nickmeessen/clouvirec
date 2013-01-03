class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :userid
      t.integer :tvdbid
      t.integer :season
      t.integer :episode
      t.boolean :processed

      t.timestamps
    end
  end
end
