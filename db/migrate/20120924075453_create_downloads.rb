class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.integer :showid
      t.integer :season
      t.integer :episode

      t.timestamps
    end
  end
end
