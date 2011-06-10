require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  setup do
    stub_request(:get, "http://www.fededirectory.frb.org/FedACHdir.txt").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "086300012O0810000451052510000000000OLD NATL BK IN EVANSVILLE           ATTN: DENISE ATKINS                 EVANSVILLE          IN477080000812468109111     \r\n086300025O0810000451012501000000000INTEGRA BANK                        P.O. BOX 868                        EVANSVILLE          IN477050868812464963511     ", :headers => {})
  end
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should download ach data successfully the first time" do
    Institution.delete_all
    assert_difference('Institution.count',2) do
      get :download
    end
    assert_redirected_to result_url
    assert_equal 'Database successfully populated', flash[:notice]
  end
  
  test "should gracefully fail if database already contains data" do
    assert_no_difference('Institution.count') do
      get :download
    end
    assert_redirected_to result_url
    assert_equal 'The following error prohibited the database from being populated: Existing Institution Data Found. Pass :update => true if you would like to update the data', flash[:notice]
  end
  
  test "should get result and contain a span with the Institution count" do
    get :result
    assert_response :success
    assert_tag :tag => "span", :attributes => { :id => "count" }
  end

end
