require 'open-uri'
class Institution < ActiveRecord::Base
  
  def record_type
    case self.record_type_code
    when 0
        'Institution is a Federal Reserve Bank'
    when 1
        'Send Items to customer routing number'
    when 2
        'Send Items to customer using new routing number'
    end      
  end
  
  def federal_reserve_bank?
    self.record_type_code.eql? 0
  end
  
  def main_branch?
    self.office_code.eql?("O")
  end
  
  def branch?
    self.office_code.eql?("B")
  end
  
  def routing_number
    self.record_type_code.eql?(2) ? self[:new_routing_number] : self[:routing_number]
  end
  
  def self.populate_database(options={})
    if Institution.count == 0
      directory = fetch_remote_data
      directory.lines.each do |institution_data|
        parser = ACH::Parser.new(institution_data)
        create({
          :routing_number => parser.routing_number,
          :office_code => parser.office_code,
          :servicing_frb_number => parser.servicing_frb_number,
          :record_type_code => parser.record_type_code,
          :change_date => parser.change_date,
          :new_routing_number => parser.new_routing_number,
          :customer_name => parser.customer_name,
          :address => parser.address,
          :city => parser.city,
          :state => parser.state_code,
          :zipcode => parser.zipcode + parser.zipcode_extension,
          :telephone => parser.telephone_area_code + parser.telephone_prefix_number + parser.telephone_suffix_number,
          :status_code => parser.institution_status_code,
          :data_view_code => parser.data_view_code
        })
      end
    elsif Institution.count > 0 && !options[:update]
      raise StandardError, "Existing Institution Data Found. Pass :update => true if you would like to update the data"
    elsif Institution.count > 0 && options[:update]
      # Update the database
    end
  end
  
  def self.fetch_remote_data
    open('http://www.fededirectory.frb.org/FedACHdir.txt') {|f| f.read }
  end
end
