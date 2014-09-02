class CreateLinksAndTags < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.belongs_to :user

      t.timestamps
    end

    create_table :tags do |t|
      t.string :text
      t.belongs_to :user
    end

    create_table :links_tags, id: false do |t|
      t.belongs_to :link
      t.belongs_to :tag
    end
  end
end
