require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase
  setup do
    Institution.delete_all
    stub_request(:get, "http://www.fededirectory.frb.org/FedACHdir.txt").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "086300012O0810000451052510000000000OLD NATL BK IN EVANSVILLE           ATTN: DENISE ATKINS                 EVANSVILLE          IN477080000812468109111     \r\n086300025O0810000451012501000000000INTEGRA BANK                        P.O. BOX 868                        EVANSVILLE          IN477050868812464963511     ", :headers => {})
    Institution.populate_database
    @test = Institution.first
  end
  
  test "Institution#fetch_remote_data should return ACH data from the web" do
    assert Institution.send(:fetch_remote_data).is_a?(String)
    assert_equal Institution.send(:fetch_remote_data).lines.to_a.size, 2
  end
  
  test "Institution#populate_database should populate the database with retrieved data" do
    Institution.delete_all
    assert_difference('Institution.count', 2) do
      Institution.populate_database
    end
    assert_equal Institution.count, 2
    first_institution = Institution.first
    second_institution = Institution.last
    assert_equal first_institution.routing_number, "086300012"
    assert_equal second_institution.routing_number, "086300025"
  end
  
  test "Institution#populate_database should raise an error if attempted to call when data exists" do
    assert_raise_message [StandardError],/Existing Institution Data Found. Pass :update => true if you would like to update the data/ do
      Institution.populate_database
    end
  end
  
  test "Institution#populate_database should update records if called with :update => true" do
    assert_equal @test.routing_number,"086300012"
    stub_request(:get, "http://www.fededirectory.frb.org/FedACHdir.txt").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "086300012O0810000452060911999999999OLD NATL BK IN EVANSVILLE           ATTN: DENISE ATKINS                 EVANSVILLE          IN477080000812468109111     \r\n086300025O0810000451012501000000000INTEGRA BANK                        P.O. BOX 868                        EVANSVILLE          IN477050868812464963511     ", :headers => {})
    Institution.populate_database(:update => true)
    @test = Institution.where(:routing_number => "086300012").first
    assert_equal @test.routing_number, "999999999"
  end
  
  test "Institution#populate_database should populate the database with the correct data" do
    assert_equal @test.routing_number, "086300012"
    assert_equal @test.office_code, "O"
    assert_equal @test.servicing_frb_number, "081000045"
    assert_equal @test.record_type_code, "1"
    assert_equal @test.change_date, Date.parse("2010-05-25")
    assert_equal @test.new_routing_number, "000000000"
    assert_equal @test.customer_name, "OLD NATL BK IN EVANSVILLE"
    assert_equal @test.address, "ATTN: DENISE ATKINS"
    assert_equal @test.city, "EVANSVILLE"
    assert_equal @test.state, "IN"    
    assert_equal @test.zipcode, "477080000"
    assert_equal @test.telephone, "8124681091"
    assert_equal @test.status_code, "1"
    assert_equal @test.data_view_code, "1"
  end
  
  test "Institution#record_type should return 'Institution is a Federal Reserve Bank' and #federal_reserve_bank? should be true if #record_type_code is 0" do
    @test.record_type_code = 0.to_s
    assert_equal @test.record_type, 'Institution is a Federal Reserve Bank'
    assert @test.federal_reserve_bank?
  end
  
  test "Institutiton#routing_number should return the stored routing number if record_type_code is not 2" do
    @test.record_type_code = 1.to_s
    assert_equal @test.routing_number, "086300012"
    @test.record_type_code = 2.to_s
    assert_equal @test.routing_number, "000000000"
  end
  
  test "Institution#main_branch? should return true if #office_code is O" do
    assert @test.main_branch?
  end
  
  test "Institution#branch? should return true if #office_code is B" do
    assert_equal @test.branch?, false
    @test.office_code = "B"
    assert @test.branch?
  end
  
end
