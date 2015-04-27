require_relative '../app'

migration "create shirt_requests" do
  database.run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'

  database.create_table :shirt_requests do
    column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
    column :iid, :serial, :null=>false

    text :email
    text :name
    text :street_one
    text :street_two
    text :city
    text :state
    text :zip

    json :company
    json :person

    text :size

    bool :confirmed, default: false

    primary_key [:id]

    index [:email], unique: true
    index [:iid], unique: true
  end
end
