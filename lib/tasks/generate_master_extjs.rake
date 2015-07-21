require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'



namespace :master_extjs do 

  task :generate_asset_and_controller_files => :environment do
    puts "the first"

 
    main_view_name = 'AM.view.operation.PurchaseDownPayment'
 
    tokenized_main_view_name = main_view_name.split('.')

    tokenized_length = tokenized_main_view_name.length
    tab_name = tokenized_main_view_name[ tokenized_length - 2 ]
    entity_name = tokenized_main_view_name[ tokenized_length - 1 ]


    tokenized_entity_name = entity_name.split /(?=[A-Z])/

    downcase_tokenized_entity_name = [] 
    tokenized_entity_name.each {|x| downcase_tokenized_entity_name << x.downcase }

   

    # if  File.directory?(TEMP_FILE_LOC)
    #   FileUtils.rm_rf( TEMP_FILE_LOC )
    # end
    # FileUtils.mkdir_p(TEMP_FILE_LOC)
     

    # File.delete( temp_file_loc )

    
    create_content_folder( tab_name, entity_name, downcase_tokenized_entity_name )
    create_view_container( tab_name, entity_name, downcase_tokenized_entity_name)
    create_view_content_folder( tab_name, entity_name, downcase_tokenized_entity_name)
    create_master_form(tab_name, entity_name, downcase_tokenized_entity_name)
    create_master_list(tab_name, entity_name, downcase_tokenized_entity_name)
    create_master_model(tab_name, entity_name, downcase_tokenized_entity_name)
    create_master_store(tab_name, entity_name, downcase_tokenized_entity_name)
    
    create_master_controller(tab_name, entity_name, downcase_tokenized_entity_name)

    create_master_server_controller_rb(tab_name, entity_name, downcase_tokenized_entity_name)
  end

  def create_content_folder( tab_name, entity_name, downcase_tokenized_entity_name )
    puts "create content folder"
    content_folder = "#{BASE_JS_APP}/view/#{tab_name}"
    if  not File.directory?( content_folder)
      FileUtils.mkdir_p(content_folder)
    end
  end

  def create_view_container( tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create  view container"
    view_container_template_file = "#{BASE_MASTER_TEMPLATE_FOLDER}/view_container.js" 
    text = File.open(  view_container_template_file ).read 

   

    text.gsub!("template.Template", "#{tab_name}.#{entity_name}")
    text.gsub!(".templateP", ".#{downcase_tokenized_entity_name.join('')}P")
    text.gsub!("templatel", "#{downcase_tokenized_entity_name.join('')}l")

    

    result_filename = BASE_JS_APP + "/view/#{tab_name}/"  + entity_name + ".js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def create_view_content_folder( tab_name, entity_name, downcase_tokenized_entity_name)

    puts "I am inside the shitty"
    folder_name = downcase_tokenized_entity_name.join('')

    content_folder = BASE_JS_APP + "/view/" + tab_name
    if  not File.directory?( content_folder)
      FileUtils.mkdir_p(content_folder)  
    end

    content_folder = content_folder + "/" + folder_name
    puts "The content folder: #{content_folder}"
    if  not File.directory?( content_folder)
      FileUtils.mkdir_p(content_folder)  
    end


  end


  def create_master_form(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_form  "
    form_template = "#{BASE_MASTER_TEMPLATE_FOLDER}/form.js" 
    text = File.open(  form_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!(".templatef", ".#{folder_name}f")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}/"  + "Form.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def create_master_list(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_list "
    list_template = "#{BASE_MASTER_TEMPLATE_FOLDER}/list.js" 
    text = File.open(  list_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!(".templatel", ".#{folder_name}l")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}/"  + "List.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def create_master_model(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_model "
    model_template = "#{BASE_MASTER_TEMPLATE_FOLDER}/model.js" 
    text = File.open(    model_template  ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}")
    text.gsub!("templates", "#{downcase_merged_entity_name}s")
    text.gsub!("template", "#{downcase_merged_entity_name}")

   

    result_filename = BASE_JS_APP + "/model/"  + "#{entity_name}.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def create_master_store(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_store "
    store_template = "#{BASE_MASTER_TEMPLATE_FOLDER}/store.js" 
    text = File.open(  store_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}") 

   

    result_filename = BASE_JS_APP + "/store/"  + "#{entity_name}s.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def create_master_controller(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_controller "
    controller_template = "#{BASE_MASTER_TEMPLATE_FOLDER}/controller.js" 
    text = File.open(  controller_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}") 
    text.gsub!("template.template", "#{tab_name}.#{folder_name}") 
    text.gsub!("templatel", "#{folder_name}l") 
    text.gsub!("templatef", "#{folder_name}f") 


   

    result_filename = BASE_JS_APP + "/controller/"  + "#{entity_name}s.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def create_master_server_controller_rb(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_server_controller "
    controller_template = "#{BASE_MASTER_TEMPLATE_FOLDER}/master_server_controller.rb" 
    text = File.open(  controller_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
    
 
   

     
    text.gsub!("Template", "#{entity_name}") 
    text.gsub!("template_", "#{downcase_merged_entity_name}_") 
    text.gsub!("template", "#{downcase_merged_entity_name}")  


   

    result_filename = BASE_CONTROLLER_FOLDER + "/api/"  + "#{downcase_merged_entity_name}s_controller.rb"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end
end
