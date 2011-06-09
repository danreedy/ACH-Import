module ACH
  FORMAT = {
    :routing_number =>  { length: 9, starting_position: 1 },
    :office_code =>  { length: 1, starting_position: 10 },
    :servicing_frb_number =>  { length: 9, starting_position: 11 },
    :record_type_code =>  { length: 1, starting_position: 20 },
    :change_date =>  { length: 6, starting_position: 21 },
    :new_routing_number =>  { length: 9, starting_position: 27 },
    :customer_name =>  { length: 36, starting_position: 36 },
    :address =>  { length: 36, starting_position: 72 },
    :city =>  { length: 20, starting_position: 108 },
    :state_code =>  { length: 2, starting_position: 128 },
    :zipcode =>  { length: 5, starting_position: 130 },
    :zipcode_extension =>  { length: 4, starting_position: 135 },
    :telephone_area_code =>  { length: 3, starting_position: 139 },
    :telephone_prefix_number =>  { length: 3, starting_position: 142 },
    :telephone_suffix_number =>  { length: 4, starting_position: 145 },
    :institution_status_code =>  { length: 1, starting_position: 149 },
    :data_view_code =>  { length: 1, starting_position: 150 },
    :filler => { length: 5, starting_position: 151 }
  }
  class Parser
    attr_accessor :raw_data
    
    def initialize(*args)
      if args[0].is_a? String
        @raw_data = args[0]
      else
        raise ArgumentError, "Expected a String but was given a #{args[0].class}"
      end
    end
    
    def method_missing(meth, *args, &blk)
      if ACH::FORMAT.keys.include?(meth)
        start_character = ACH::FORMAT[meth][:starting_position]-1
        end_character = (start_character + ACH::FORMAT[meth][:length])-1
        range = start_character..end_character
        if meth.to_s =~ /date/
          Date.strptime(@raw_data[range],"%m%d%y")
        else
          @raw_data[range].strip
        end        
      end
    end
  end
end