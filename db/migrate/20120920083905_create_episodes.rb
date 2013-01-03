class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :tvdbid
      t.string :title
      t.date :airdate

      t.timestamps
    end
  end
end
