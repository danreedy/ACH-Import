require 'test_helper'

class AchTest < ActiveSupport::TestCase
  
  setup do
    @one_institution = "086300012O0810000451052510000000000OLD NATL BK IN EVANSVILLE           ATTN: DENISE ATKINS                 EVANSVILLE          IN477080000812468109111     "
    @parser = ACH::Parser.new(@one_institution)
  end

  test "ACH::Parser should raise an error unless a string is passed" do
    assert_raise_message [ArgumentError],/^Expected a String but was given a/ do
      ACH::Parser.new(Date.today)
    end
  end
  
  test "ACH::Parser should not fail if a String is passed" do
    assert_equal @parser.class, ACH::Parser
    assert_equal @parser.raw_data, @one_institution
  end
  
  test "ACH::Parser#routing_number should return a 9 String character for the routing number" do
    assert_equal @parser.routing_number.size, 9
    assert_equal @parser.routing_number, "086300012"
  end
  
  test "ACH::Parser#office_code should return a 1 character String for the office code" do
    assert_equal @parser.office_code.size, 1
    assert_equal @parser.office_code, "O"
  end
  
  test "ACH::Parser#servicing_frb_number should return a 9 character String for the FRB number" do
    assert_equal @parser.servicing_frb_number.size, 9
    assert_equal @parser.servicing_frb_number, "081000045"
  end
  
  test "ACH::Parser#record_type_code should return a 1 character String for the code" do
    assert_equal @parser.record_type_code.size, 1
    assert_equal @parser.record_type_code, "1"
  end
  
  test "ACH::Parser#change_date should return a Date object" do
    assert_equal @parser.change_date.is_a?(Date), true
    assert_equal @parser.change_date, Date.parse("2010-05-25")
  end
  
  test "ACH::Parser#new_routing_number should return a 9 character string" do
    assert_equal @parser.new_routing_number.size, 9
    assert_equal @parser.new_routing_number, "000000000"
  end
  
  test "ACH::Parser#customer_name should return a String between 1-36 characters" do
    assert @parser.customer_name.size >= 1 && @parser.customer_name.size <= 36
    assert_equal @parser.customer_name, "OLD NATL BK IN EVANSVILLE"
  end
  
  test "ACH::Parser#address should return a String between 1-36 characters" do
    assert @parser.address.size >= 1 && @parser.address.size <= 36
    assert_equal @parser.address, "ATTN: DENISE ATKINS"
  end
  
  test "ACH::Parser#city should return a String between 1-20 characters" do
    assert @parser.city.size >= 1 && @parser.city.size <= 20
    assert_equal @parser.city, "EVANSVILLE"
  end
  
  test "ACH::Parser#state_code should return a 2 character String for the state" do
    assert_equal @parser.state_code.size, 2
    assert_equal @parser.state_code, "IN"    
  end
  
  test "ACH::Parser#zipcode should return a 5 character zipcode" do
    assert_equal @parser.zipcode.size, 5
    assert_equal @parser.zipcode, "47708"
  end
  
  test "ACH::Parser#zipcode_extension should return a 4 character zipcode extension" do
    assert_equal @parser.zipcode_extension.size, 4
    assert_equal @parser.zipcode_extension, "0000"
  end
  
  test "ACH::Parser#telephone_area_code should return a 3 character area code" do
    assert_equal @parser.telephone_area_code.size, 3
    assert_equal @parser.telephone_area_code, "812"
  end
  
  test "ACH::Parser#telephone_prefix_number should return a 3 character prefix" do
    assert_equal @parser.telephone_prefix_number.size, 3
    assert_equal @parser.telephone_prefix_number, "468"
  end
  
  test "ACH::Parser#telephone_suffix_number should return a 4 character suffix" do
    assert_equal @parser.telephone_suffix_number.size, 4
    assert_equal @parser.telephone_suffix_number, "1091"
  end
  
  test "ACH::Parser#institution_status_code should return a 1 character code" do
    assert_equal @parser.institution_status_code.size, 1
    assert_equal @parser.institution_status_code, "1"
  end
  
  test "ACH::Parser#data_view_code should return a 1 character code" do
    assert_equal @parser.data_view_code.size, 1
    assert_equal @parser.data_view_code, "1"
  end
end
