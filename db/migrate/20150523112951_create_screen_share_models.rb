class CreateScreenShareModels < ActiveRecord::Migration
  def change
    create_table :screen_shares do |t|
      t.string :recording_id

      t.belongs_to :test

      t.timestamps
    end

    create_table :screen_share_events do |t|
      t.string :event_type

      t.belongs_to :screen_share

      t.timestamps
    end

    create_table :screen_share_files do |t|
      t.string :url
      t.references :screen_share_event

      t.timestamps
    end
  end
end
