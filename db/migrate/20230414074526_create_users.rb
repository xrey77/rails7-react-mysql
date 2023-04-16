class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.index [:lastname, :firstname],unique: true
      t.string :lastname
      t.string :firstname
      t.string :emailadd, unique: true
      t.index :emailadd, unique: true
      t.string :mobileno
      t.string :username, unique: true
      t.index :username, unique: true
      t.string :password
      t.string :role, default: 'USER'
      t.text :secretkey
      t.text :picture
      t.integer :isactivated, default: 0
      t.integer :isblocked, default: 0
      t.integer :mailtoken, default: 0
      t.text :qrcodeurl
      t.timestamp :datecreated, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :dateupdated
    end
  end
end
