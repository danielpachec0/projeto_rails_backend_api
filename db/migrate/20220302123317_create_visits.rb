class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.datetime :date
      t.string :status
      t.datetime :checkin_at
      t.datetime :checkout_at

      t.timestamps
    end
  end
end
