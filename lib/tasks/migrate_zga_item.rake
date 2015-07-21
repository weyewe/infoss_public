require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :migrate_zga do 

  
  task :independent_item => :environment do
    
    core_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:core]
    roller_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:roller]
    blanket_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:blanket]
    
    # puts "core_item_type: #{core_item_type.id}"
    # puts "roller_item_type: #{roller_item_type.id}"
    # puts "blanket_item_type: #{blanket_item_type.id}"
    
    item_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item_type] ) 
    sub_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:sub_type] )  
    uom_mapping_hash  = get_mapping_hash( MIGRATION_FILENAME[:uom])
    exchange_mapping_hash = get_mapping_hash( MIGRATION_FILENAME[:exchange]) 
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME ) 
    
 
    
    migration_filename = MIGRATION_FILENAME[:item]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
           

          id = row[0]
          item_type_id = row[1]
          sub_type_id = row[2]
          sku = row[3]
          name = row[4]
          description = row[5]
          is_tradeable = row[6]
          uom_id = row[7]
          minimum_quantity = row[12]
          selling_price = row[15]
          price_list = row[16]
          exchange_id = row[17]
          is_deleted = row[21] 
 
 
          new_item_type_id =  item_type_mapping_hash[item_type_id] 
          new_sub_type_id = sub_type_mapping_hash[sub_type_id]
          new_uom_id = uom_mapping_hash[uom_id]
          new_exchange_id = exchange_mapping_hash[exchange_id]
          
          
          if selling_price.to_i == 0
            selling_price = "100"
          end
          
          if minimum_quantity.to_i == 0
            minimum_quantity = "100"
          end
          
          if price_list.to_i == 0
            price_list = "100"
          end
          
          
          
          if new_exchange_id.nil?
            new_exchange_id = base_exchange.id 
          end
          
          next if new_item_type_id.to_i == core_item_type.id or 
                  new_item_type_id.to_i == roller_item_type.id or 
                  new_item_type_id.to_i == blanket_item_type.id
            
          is_deleted = false 
          is_deleted  = true if row[21] == "True" 
          
          next if is_deleted 
          
          is_tradeable = false 
          is_tradeable  = true if row[6] == "True" 
          
 
          object = Item.create_object(
              :item_type_id => new_item_type_id ,
              :sub_type_id => new_sub_type_id,
              :sku => sku,
              :name => name,
              :description => description,
              :is_tradeable => is_tradeable,
              :uom_id => new_uom_id,
              :minimum_amount => minimum_quantity,
              :selling_price => selling_price,
              :exchange_id => new_exchange_id,
              :price_list => price_list
            )
          
          object.errors.messages.each do |x|
            puts "error: #{x}. Old id: #{id}. #{row[21]}" 
            puts "item_type_id : #{item_type_id}"
            puts "new_item_type_id : #{new_item_type_id}"
          end
            
 
           

            result_array << [ id , 
                    object.id , 
                    object.sku  ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating  independent Item. Total independent item : #{Item.count}"
  end
  
  
  task :blanket => :environment do
    
    item_type_mapping_hash = get_mapping_hash(MIGRATION_FILENAME[:item_type])
    uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
    contact_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:contact] )  
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
    item_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item] )  
    exchange_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:exchange] )  
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME )  
    
    migration_filename = MIGRATION_FILENAME[:blanket]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
           
 
  
    
 
            roll_no = row[0]
            contact_id = row[1]
            machine_id = row[2]
            adhesive_id = row[3]
            adhesive2_id = row[4]
            roll_blanket_item_id = row[5]  # can't be empty
            left_bar_item_id = row[6] # can be empty
            right_bar_item_id = row[7] # can be empty
            ac = row[8]
            ar = row[9]
            thickness = row[10] 
            is_bar_required = row[12]
 
            cropping_type = row[15]  # Normal Special NO
            left_over_ac = row[16]
            left_over_ar = row[17]
            special = row[18]  # string 
            application_case = row[19]   # Sheetfed Web Both
            
          id = row[20]
          
      
           sku = row[23]
           name = row[24]
            description = row[25] 
          uom_id = row[27] 
 
          minimum_quantity = row[32] 
          selling_price = row[35]
          price_list = row[36]
          exchange_id = row[37] 
          is_deleted = row[41]
          
          
           
          is_bar_required = false 
          is_bar_required  = true if row[12] == "True" 
          
          is_deleted = false 
          is_deleted  = true if row[41] == "True" 
          
          next if is_deleted 
          
          # edit the application_case and the cropping_type
          application_case = APPLICATION_CASE[:sheetfed] if application_case == "Sheetfed"
          application_case = APPLICATION_CASE[:web] if application_case == "Web"
          application_case = APPLICATION_CASE[:both] if application_case == "Both"
          
          cropping_type = CROPPING_TYPE[:normal] if cropping_type == "Normal"
          cropping_type = CROPPING_TYPE[:special] if cropping_type == "Special"
          cropping_type = CROPPING_TYPE[:none] if cropping_type == "NO"
          
 
          new_uom_id =  uom_mapping_hash[uom_id] 
          new_exchange_id =  uom_mapping_hash[exchange_id]
          new_machine_id =  machine_mapping_hash[exchange_id] 
          new_contact_id =  contact_mapping_hash[contact_id] 
          
     
          new_adhesive_id =  item_mapping_hash[adhesive_id] if not adhesive_id.nil? 
          if not adhesive_id.nil?  and new_adhesive_id.nil?
            puts "damn, the new_adhesive_id is nil"
            next
          end
          
          new_adhesive2_id =  item_mapping_hash[adhesive2_id] if not adhesive2_id.nil? 
          if not adhesive2_id.nil?  and new_adhesive2_id.nil?
            puts "damn, the new_adhesive_id is nil"
            next
          end
          
          new_roll_blanket_item_id =  item_mapping_hash[roll_blanket_item_id] 
          new_left_bar_item_id =  item_mapping_hash[left_bar_item_id]  if not left_bar_item_id.nil? 
          if not left_bar_item_id.nil?  and new_left_bar_item_id.nil?
            puts "damn, the new_left_bar_item_id is nil"
            next
          end
          
          new_right_bar_item_id =  item_mapping_hash[right_bar_item_id]  if not right_bar_item_id.nil? 
          if not right_bar_item_id.nil?  and new_right_bar_item_id.nil?
            puts "damn, the new_right_bar_item_id is nil"
            next 
          end
          
          
          error  = false 
          if Uom.find_by_id( new_uom_id.to_i ).nil?
            puts "fucka.. id #{new_uom_id} has no corresponding new uom "
            error = true 
          end
          

          
          if Machine.find_by_id( new_machine_id.to_i ).nil?
            puts "fucka.. id #{new_machine_id} has no corresponding new machine_id "
            error = true 
          end
          
          
          if Exchange.find_by_id( new_exchange_id.to_i ).nil?
            puts "fucka.. id #{new_exchange_id} has no corresponding new exchange_id "
            error = true 
          end
          
          if Contact.find_by_id( new_contact_id.to_i ).nil?
            puts "fucka.. id #{new_contact_id} has no corresponding new contact_id "
            error = true 
          end
          
          if Item.find_by_id( new_roll_blanket_item_id.to_i ).nil?
            puts "fucka.. id #{new_roll_blanket_item_id} has no corresponding new item_id "
            error = true 
          end
          
    
          next if error 
          
          
    
          
          object = Blanket.create_object(
            :sku => sku,
            :name => name,
            :description => description,
            :uom_id => new_uom_id,
            :roll_no => roll_no ,
            :contact_id => new_contact_id,
            :machine_id =>  new_machine_id,
            :adhesive_id => new_adhesive_id,
            :adhesive2_id => new_adhesive2_id,
            :roll_blanket_item_id =>  new_roll_blanket_item_id,
            :left_bar_item_id => new_left_bar_item_id,
            :right_bar_item_id => new_right_bar_item_id,
            :ac => ac,
            :ar => ar,
            :thickness => thickness,
            :is_bar_required => is_bar_required,
            :cropping_type => cropping_type,
            :special => special,
            :application_case => application_case,
            :left_over_ac => left_over_ac,
            :left_over_ar => left_over_ar,
            :minimum_amount => BigDecimal("1"),
            :selling_price => BigDecimal("2000"),
            :price_list => BigDecimal("500"),
            :exchange_id =>  new_exchange_id,
          )

            object.errors.messages.each {|x| puts "blanket migration error. old id : #{id}. message: #{x}"}
          
           

            result_array << [ id , 
                    object.id   ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    
    # update the item lookup table to accomodate core 
    
    migration_filename = MIGRATION_FILENAME[:item] 
    item_original_location  = original_file_location( migration_filename )
    item_lookup_location =  lookup_file_location(  migration_filename ) 
    
  
    
    original_blanket_item_type_hash  = {} 
    awesome_row_counter = - 1 
    blanket_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:blanket]
    
    CSV.open(item_original_location, 'r') do |csv| 
      csv.each do |row| 
        awesome_row_counter = awesome_row_counter + 1  
        next if awesome_row_counter == 0 
         

        id = row[0]
        item_type_id = row[1] 
        sku = row[3]
 
        
        
        is_deleted = false 
        is_deleted  = true if row[21] == "True" 
        
        next if is_deleted 
        new_item_type_id =  item_type_mapping_hash[item_type_id] 
        if  new_item_type_id.to_i == blanket_item_type.id
          puts "Sku: #{sku}"
          original_blanket_item_type_hash[sku] = id 
        end 
        
      end
    end
    
    puts "The content of original_blanket_item_type_hash: "
    puts original_blanket_item_type_hash
    
    CSV.open(item_lookup_location, 'a') do |csv|
      result_array.each do |el| 
        blanket = Blanket.find_by_id el[1]
        next if blanket.nil? 
        
 
        
        blanket_old_id = original_blanket_item_type_hash[blanket.sku] 
        
   
        
        csv << [ blanket_old_id, blanket.id, blanket.sku ]  
      
      end
    end
    
    
    puts "Done migrating Blanket. Total Blanket : #{Blanket.count}"
  end
  
  task :core_builder => :environment do
    
    uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
    item_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:item_type] )  
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME ) 
    # puts "the contact group mapping hash"
    # puts "#{contact_group_mapping_hash}"
    
    migration_filename = MIGRATION_FILENAME[:core_builder]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
           
        
          id = row[0]
          sku = row[1] 
          uom_id = row[6]
          machine_id = row[7]
          core_builder_type_case = row[8]
          name = row[9]
          description = row[10]
          cd = row[11]
          tl = row[12]
          
 
          
          
          is_deleted = false 
          is_deleted  = true if row[13] == "True" 
          
          next if is_deleted 
          
 

          if core_builder_type_case == "None"
            core_builder_type_case = CORE_BUILDER_TYPE[:none]
          end
          
          if core_builder_type_case == "Shaft"
            core_builder_type_case = CORE_BUILDER_TYPE[:shaft]
          end
          
          if core_builder_type_case == "Hollow"
            core_builder_type_case = CORE_BUILDER_TYPE[:hollow]
          end
          
           
          new_uom_id =  uom_mapping_hash[uom_id] 
          
          if Uom.find_by_id( new_uom_id.to_i ).nil?
            puts "fucka.. id #{new_uom_id} has no corresponding new uom "
          end
          
          new_machine_id =  machine_mapping_hash[machine_id] 
          
          if Machine.find_by_id( new_machine_id.to_i ).nil?
            puts "fucka.. id #{new_machine_id} has no corresponding new machine_id "
          end
          
          
    
          
          object = CoreBuilder.create_object(
            :base_sku => sku,
            :name => name,
            :description => description,
            :uom_id => new_uom_id,
            :machine_id =>  new_machine_id,
            :core_builder_type_case => core_builder_type_case,
            :cd => cd,
            :tl => tl
            )

            
          
           

            result_array << [ id , 
                    object.id , 
                    object.base_sku  ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    
    # update the item lookup table to accomodate core 
    
    migration_filename = MIGRATION_FILENAME[:item] 
    item_original_location  = original_file_location( migration_filename )
    item_lookup_location =  lookup_file_location(  migration_filename ) 
    
  
    
    original_core_item_type_hash  = {} 
    awesome_row_counter = - 1 
    core_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:core]
    
    CSV.open(item_original_location, 'r') do |csv| 
      csv.each do |row| 
        awesome_row_counter = awesome_row_counter + 1  
        next if awesome_row_counter == 0 
         

        id = row[0]
        item_type_id = row[1] 
        sku = row[3]
 
        
        
        is_deleted = false 
        is_deleted  = true if row[21] == "True" 
        
        next if is_deleted 
        new_item_type_id =  item_type_mapping_hash[item_type_id] 
        if  new_item_type_id.to_i == core_item_type.id
          puts "Sku: #{sku}"
          original_core_item_type_hash[sku] = id 
        end 
        
      end
    end
    
    puts "The content of original_core_item_type_hash: "
    puts original_core_item_type_hash
    
    CSV.open(item_lookup_location, 'a') do |csv|
      result_array.each do |el| 
        core_builder = CoreBuilder.find_by_id el[1]
        new_core_item = core_builder.new_core_item
        used_core_item = core_builder.used_core_item 
        
        new_core_old_id = original_core_item_type_hash[new_core_item.sku]
        used_core_old_id = original_core_item_type_hash[new_core_item.sku]
        
        if new_core_old_id.nil? or used_core_old_id.nil?
          puts "there is no mapping for base_sku : #{core_builder.base_sku}"
        end
        
        csv << [ new_core_old_id, new_core_item.id, new_core_item.sku ] 
        csv << [ used_core_old_id, used_core_item.id, used_core_item.sku ] 
      
      end
    end
    
    
    puts "Done migrating core builder. Total core builder : #{CoreBuilder.count}"
  end
  
  task :roller_type => :environment do
 
    migration_filename = MIGRATION_FILENAME[:roller_type]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
           
          id = row[0]
          name = row[1]
          description = row[2]
          is_deleted = row[3]
 
          
          
          is_deleted = false 
          is_deleted  = true if row[3] == "True" 
          
          next if is_deleted 
          
 
          object = RollerType.create_object(
            :name => name,
            :description => description
            )
          
 
           

            result_array << [ id , 
                    object.id , 
                    object.name  ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    puts "Done migrating core RollerType. Total roller type : #{RollerType.count}"
  end
  
  
  task :roller_builder => :environment do
       
       
    uom_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:uom] ) 
    machine_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:machine] )  
    roller_type_mapping_hash = get_mapping_hash(  MIGRATION_FILENAME[:roller_type] ) 
    item_mapping_hash = get_mapping_hash( MIGRATION_FILENAME[:item])
    core_builder_mapping_hash = get_mapping_hash(MIGRATION_FILENAME[:core_builder])
    item_type_mapping_hash = get_mapping_hash(MIGRATION_FILENAME[:item_type])
    base_exchange = Exchange.find_by_name( EXCHANGE_BASE_NAME )  
    
    migration_filename = MIGRATION_FILENAME[:roller_builder]
    original_location =   original_file_location( migration_filename )
    lookup_location =  lookup_file_location(  migration_filename ) 
    result_array = [] 
    awesome_row_counter = - 1 
    
    CSV.open(original_location, 'r') do |csv| 
        csv.each do |row| 
          awesome_row_counter = awesome_row_counter + 1  
          next if awesome_row_counter == 0 
          
   
          id = row[0]
          machine_id = row[1]
          roller_type_id = row[2]
          compound_id = row[3]
          core_builder_id = row[4]
          base_sku = row[5] 
          adhesive_id = row[10]
          uom_id = row[11]
          name = row[12]
          description = row[13]
          rd = row[14]
          cd = row[15]
          rl = row[16]
          wl = row[17]
          tl = row[18]
          is_crowning = row[19]
          crowning_size = row[20]
          is_grooving = row[21]
          grooving_width = row[22]
          grooving_depth = row[23]
          grooving_position = row[24]
          is_chamfer = row[25]
           
           
          is_deleted = false 
          is_deleted  = true if row[26] == "True" 
          
          next if is_deleted 
          
          is_chamfer = false 
          is_chamfer  = true if row[25] == "True" 
          
          is_grooving = false 
          is_grooving  = true if row[21] == "True" 
          
          is_crowning = false 
          is_crowning  = true if row[19] == "True" 
    
          
          new_machine_id = machine_mapping_hash[machine_id]
          new_uom_id =  uom_mapping_hash[uom_id] 
          new_roller_type_id = roller_type_mapping_hash[roller_type_id]
          new_compound_id  = item_mapping_hash[compound_id]
          new_core_builder_id = core_builder_mapping_hash[core_builder_id]
          new_adhesive_id  = item_mapping_hash[adhesive_id]
          
          
          if Uom.find_by_id( new_uom_id.to_i ).nil?
            puts "fucka.. uom id #{uom_id} has no corresponding new uom "
          end 
          
          if Machine.find_by_id( new_machine_id.to_i ).nil?
            puts "fucka.. machine id #{machine_id} has no corresponding new machine "
          end 
          
          if RollerType.find_by_id( new_roller_type_id.to_i ).nil?
            puts "fucka.. roller type id #{roller_type_id} has no corresponding new roller type "
          end 

          if Item.find_by_id( new_compound_id.to_i ).nil?
            puts "fucka.. compound id #{compound_id} has no corresponding new compound "
          end 
          
          if CoreBuilder.find_by_id( new_core_builder_id.to_i ).nil?
            puts "fucka.. corebuilder id #{core_builder_id} has no corresponding new core builder "
          end 
          
          if Item.find_by_id( new_adhesive_id.to_i ).nil?
            puts "fucka.. adhsive id #{adhesive_id} has no corresponding new adhesive "
          end 
          
          
   

          
          
          object = RollerBuilder.create_object(
            :base_sku => base_sku,
            :name => name,
            :description => description,
            :uom_id => new_uom_id,
            :adhesive_id => new_adhesive_id,
            :compound_id => new_compound_id,
            :machine_id => new_machine_id,
            :roller_type_id => new_roller_type_id,
            :core_builder_id => new_core_builder_id,
            :is_grooving => is_grooving ,
            :is_crowning =>  is_crowning,
            :is_chamfer => is_chamfer,
            :crowning_size =>  crowning_size,
            :grooving_width => grooving_width,
            :grooving_depth => grooving_depth,
            :grooving_position => grooving_position,
            :cd => cd,
            :rd => rd,
            :rl => rl,
            :wl => wl,
            :tl => tl
            )

            
          
          object.errors.messages.each {|x| puts "err id #{id}: #{x}" }

            result_array << [ id , 
                    object.id , 
                    object.base_sku  ]

        end
        
    end
    
    CSV.open(lookup_location, 'w') do |csv|
      result_array.each do |el| 
        csv <<  el 
      end
    end
    
    
    # update the item lookup table to accomodate roller 
    
    migration_filename = MIGRATION_FILENAME[:item] 
    item_original_location  = original_file_location( migration_filename )
    item_lookup_location =  lookup_file_location(  migration_filename ) 
    
  
    
    original_roller_item_type_hash  = {} 
    awesome_row_counter = - 1 
    roller_item_type = ItemType.find_by_name BASE_ITEM_TYPE[:roller]
    
    CSV.open(item_original_location, 'r') do |csv| 
      csv.each do |row| 
        awesome_row_counter = awesome_row_counter + 1  
        next if awesome_row_counter == 0 
         

        id = row[0]
        item_type_id = row[1] 
        sku = row[3]
 
        
        
        # is_deleted = false 
        # is_deleted  = true if row[21] == "True" 
        
        # next if is_deleted 
        new_item_type_id =  item_type_mapping_hash[item_type_id] 
        if  new_item_type_id.to_i == roller_item_type.id
          puts "Sku: #{sku}"
          original_roller_item_type_hash[sku] = id 
        end 
        
      end
    end
    
    puts "The content of original_roller_item_type_hash: "
    puts original_roller_item_type_hash
    
    CSV.open(item_lookup_location, 'a') do |csv|
      result_array.each do |el| 
 
        roller_builder = RollerBuilder.find_by_id el[1]
        
        if roller_builder.nil?
          puts "id: #{el[1]} is blank"
          next
        end
        new_roller_item = roller_builder.roller_new_core_item
        used_roller_item = roller_builder.roller_used_core_item 
        
        new_roller_old_id = original_roller_item_type_hash[new_roller_item.sku]
        used_roller_old_id = original_roller_item_type_hash[used_roller_item.sku]
        
        if new_roller_old_id.nil? or used_roller_old_id.nil?
          puts "there is no roller builder  mapping for base_sku : #{roller_builder.base_sku}"
        end
        
        csv << [ new_roller_old_id, new_roller_item.id, new_roller_item.sku ] 
        csv << [ used_roller_old_id, used_roller_item.id, used_roller_item.sku ] 
      
      end
    end
    
    puts "Done migrating roller builder. Total core builder : #{RollerBuilder.count}"
  end
 
  
end