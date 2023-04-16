class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :descriptions
      t.integer :qty
      t.string :unit
      t.decimal :cost_price, precision: 10, scale: 2
      t.decimal :sell_price, precision: 10, scale: 2
      t.string :prod_pic
      t.string :category
      t.decimal :sale_price, precision: 10, scale: 2
      t.integer :alert_level
      t.integer :critical_level
      t.timestamp :datecreated, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :dateupdated
    end
  end
end
