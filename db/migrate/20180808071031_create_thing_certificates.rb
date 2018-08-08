class CreateThingCertificates < ActiveRecord::Migration[5.2]
  def change
    create_table :thing_certificates do |t|
      t.string :serial_number
      t.text :public_key
      t.text :private_key
      t.text :certificate

      t.timestamps
    end
  end
end
