ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.column "name",  :text
    t.column "email", :text
    t.column "phone_number", :text
  end
end