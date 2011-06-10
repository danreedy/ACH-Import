class HomeController < ApplicationController

  def download
    begin
      Institution.populate_database
      flash[:notice] = "Database successfully populated"
    rescue Exception => e
      flash[:notice] = "The following error prohibited the database from being populated: #{e.message}"
    end
    redirect_to result_path
  end
  
  def result
    @count = Institution.count
  end
end
