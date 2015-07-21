require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'

 
task :generate_json_view do 
    base_path = Rails.root.to_s + "/" + "app/views/" 
    view_api_folder =  base_path + "api/*"
    
    filename_array = [
        "_objects.json.jbuilder",
        "show.json.jbuilder",
        "update.json.jbuilder"
    ]
    
    Dir[ view_api_folder ].each do |folder_location|
        
        
        filename_array.each do | filename |
            full_filename_location = "#{folder_location}/#{filename}"
            
            if File.exist?(full_filename_location)
                puts "#{full_filename_location} exists"
            else
                
                base_json_template_folder = "#{Rails.root.to_s}/lib/tasks/json_view"
                
                puts "gonna generate : #{full_filename_location}"
                form_template = "#{base_json_template_folder}/#{filename}" 
                text = File.open(  form_template ).read 
            
               
            
                result_filename =  full_filename_location
                File.open(result_filename, 'w') { |file| file.write( text ) }  
                 
            end
        end
        
    end
end

task :move_index_to_objects_partial do 
    puts "gonna move it"
    base_path = Rails.root.to_s + "/" + "app/views/" 
    view_api_folder =  base_path + "api/*"
    
 
    Dir[ view_api_folder ].each do |folder_location|
        
        
        


         
        index_filename_location = "#{folder_location}/index.json.jbuilder"
        objects_filename_location = "#{folder_location}/_objects.json.jbuilder"
        
        if File.exist?(index_filename_location) and File.exist?(objects_filename_location)
            base_result = ""
            partial_block_result = "" 
            final_result  = "" 
            
            start_copy = false 
            File.open(index_filename_location).each do |line|
               base_result << line
               
               start_copy = true if line.include?("@objects") and line.include?("do")
               
               if start_copy
                   partial_block_result << line 
               end
               
               
            end
            
            final_result = base_result.gsub( partial_block_result, '')
            final_result << "json.partial! 'objects', objects:  @objects"
            
            if partial_block_result.length != 0
                
                
                puts "gonna replace the index: #{index_filename_location}"
                target_content = partial_block_result.gsub("@objects", "objects")
                File.open(objects_filename_location, 'w') { |file| file.write( target_content ) }
                File.open(index_filename_location, 'w') { |file| file.write( final_result ) }
                # puts target_content
                # break
            end
            # puts final_result
             
        end  
    end
end

task :fix_controller_respond_in_update  do 
    base_path = Rails.root.to_s + "/" + "app/controllers/" 
    controller_api_folder =  base_path + "api/*"
    
 
    Dir[ controller_api_folder ].each do |filename|
        
         
        if File.exist?(filename)  
            base_result = ""
            update_block_result = ""
            show_block_result = ""  
            
            update_copy = false
            update_copy_render = false 
            update_copy_render_block = ""
            total_line = "" 
            show_copy = false 
            File.open(filename).each do |line| 
               base_result << line 
               update_copy = true if line.include?("def") and line.include?("update")
               
               update_copy = false if line.include?("def") and not line.include?("update")
               
               if update_copy
                   update_copy_render  = true if line.include?("success") and line.include?("true")
                   update_copy_render  = false if line.include?("else")
                   
                   update_block_result << line 
                   
                   if update_copy_render 
                       
                      update_copy_render_block << line 
                      
                      if line.include?("total")
                          total_line << line 
                      end
                  end
                   
                   
               end
               
               
               
               
               
            end
            
            # puts "the update copy render block"
            # puts update_copy_render_block
            # puts "\n\n\n\n\n\n The total line"
            # puts total_line
            str = total_line
            result = str.gsub(/\s+/m, ' ').strip.split(" ")
            new_line = "      @total = #{result[2]}\n"
            
            # puts "the new line"
            # puts new_line
            
            # puts "The update_copy_render_block content length : #{update_copy_render_block.length}"
            # puts update_copy_render_block
            
            if update_copy_render_block.length != 0
              result_file_content = base_result.gsub(update_copy_render_block, new_line)
              puts "updating file: #{filename}"
              File.open(filename, 'w') { |file| file.write( result_file_content ) }
            else
              puts ">>>>>>>>>> no matching block"
            end
            
       
             
        end   
    end
end

task :fix_controller_respond_in_show do 
    base_path = Rails.root.to_s + "/" + "app/controllers/" 
    controller_api_folder =  base_path + "api/*"
    
 
    Dir[ controller_api_folder ].each do |filename|
        
         
        if File.exist?(filename)  
            base_result = ""
            update_block_result = ""
            show_block_result = ""  
            
            show_copy = false
            show_copy_render = false 
            show_copy_render_block = ""
            total_line = "" 
            show_copy = false 
            File.open(filename).each do |line| 
               base_result << line 
               show_copy = true if line.include?("def") and line.include?("show")
               
               show_copy = false if line.include?("def") and not line.include?("show")
               
               if show_copy
                   show_copy_render  = true if line.include?("success") and line.include?("true")
                   show_copy_render  = false if line.include?(" end")
                   
                   show_block_result << line 
                   
                  # puts show_copy_render
                  # puts line
                   
                   if show_copy_render 
                       
                      show_copy_render_block << line 
                      
                      if line.include?("total")
                          total_line << line 
                      end
                  end
                   
                   
               end
               
               
               
               
               
            end
            
            # puts "show block result:"
            # puts show_block_result
            
            # puts "The filename  : #{filename}"
            # puts "the show copy render block"
            # puts show_copy_render_block
            # puts "\n\n\n\n\n\n The total line"
            # puts total_line
            str = total_line
            result = str.gsub(/\s+/m, ' ').strip.split(" ")
            # puts "The result"
            # puts result 
            
            new_line = "    @total = #{result[2]}\n"
            # puts "The new line"
            # puts new_line
            
            if show_copy_render_block.length != 0
              result_file_content = base_result.gsub(show_copy_render_block, new_line)
              puts "updating file: #{filename}"
              File.open(filename, 'w') { |file| file.write( result_file_content ) }
            else
              puts ">>>>>>>>>> no matching block"
            end
            
       
             
        end 
        # break 
    end
end