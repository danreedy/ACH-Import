class CreateInstitutions < ActiveRecord::Migration
  def self.up
    create_table :institutions do |t|
      t.string :routing_number
      t.string :office_code
      t.string :servicing_frb_number
      t.string :record_type_code
      t.date :change_date
      t.string :new_routing_number
      t.string :customer_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :telephone
      t.string :status_code
      t.string :data_view_code

      t.timestamps
    end
  end

  def self.down
    drop_table :institutions
  end
end
