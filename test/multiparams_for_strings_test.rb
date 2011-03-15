require 'test/test_helper'

class MultiparamsForStringsTest < ActiveSupport::TestCase
  
  test "assigning with 3 multiparam values should return one value" do
    @some_user = User.new("phone_number(1s)" => "333", "phone_number(2s)" => "444", "phone_number(3s)" => "5555")
    assert_equal "3334445555", @some_user.phone_number
  end  
end
