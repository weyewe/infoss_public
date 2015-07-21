require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'

 


namespace :master_detail_extjs do
  task :generate_asset_and_controller_files => :environment do
    puts "the first"
 
    main_view_name = 'AM.view.operation.BankAdministration'
 
    tokenized_main_view_name = main_view_name.split('.')

    tokenized_length = tokenized_main_view_name.length
    tab_name = tokenized_main_view_name[ tokenized_length - 2 ]
    entity_name = tokenized_main_view_name[ tokenized_length - 1 ]


    tokenized_entity_name = entity_name.split /(?=[A-Z])/

    downcase_tokenized_entity_name = [] 
    tokenized_entity_name.each {|x| downcase_tokenized_entity_name << x.downcase }

   

   
    
    md_create_content_folder( tab_name, entity_name, downcase_tokenized_entity_name )
    md_create_view_container( tab_name, entity_name, downcase_tokenized_entity_name)
    puts "???????????????????????? Gonna execute view content folder \n"*10
    md_create_view_content_folder( tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_form(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_confirm_form(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_unconfirm_form(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_list(tab_name, entity_name, downcase_tokenized_entity_name)

    md_create_master_model(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_store(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_controller(tab_name, entity_name, downcase_tokenized_entity_name)


    md_create_detail_form(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_detail_list(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_detail_model(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_detail_store(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_detail_controller(tab_name, entity_name, downcase_tokenized_entity_name)

    md_create_master_detail_master_server_controller_rb(tab_name, entity_name, downcase_tokenized_entity_name)
    md_create_master_detail_detail_server_controller_rb(tab_name, entity_name, downcase_tokenized_entity_name)
    
  end

  def md_create_content_folder( tab_name, entity_name, downcase_tokenized_entity_name )
    puts "23424 gonna create content folder"
    content_folder = "#{BASE_JS_APP}/view/#{tab_name}"
    puts ">>>>>>>>>>>> contnet_folder: #{content_folder}"
    if  not File.directory?( content_folder) 
      FileUtils.mkdir_p(content_folder)
    end
    
  end

  def md_create_view_container( tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create view container"
    view_container_template_file = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/view_container.js" 
    text = File.open(  view_container_template_file ).read 

   

    text.gsub!("template.Template", "#{tab_name}.#{entity_name}")
    text.gsub!("templatel", "#{downcase_tokenized_entity_name.join('')}l")
    text.gsub!(".templateP", ".#{downcase_tokenized_entity_name.join('')}P")
    text.gsub!("templated", "#{downcase_tokenized_entity_name.join('')}d")

    

    result_filename = BASE_JS_APP + "/view/#{tab_name}/"  + entity_name + ".js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_view_content_folder( tab_name, entity_name, downcase_tokenized_entity_name)
    puts ">>>>>>>>>>>>>>>>>>> creating view content folder"
   
    folder_name = downcase_tokenized_entity_name.join('')

    content_folder = BASE_JS_APP + "/view/" + tab_name
    if  not File.directory?( content_folder)
      FileUtils.mkdir_p(content_folder)  
    end

    content_folder = content_folder + "/" + folder_name
    if  not File.directory?( content_folder)
      FileUtils.mkdir_p(content_folder)  
    end

    content_folder = content_folder + 'detail'
    puts "building this folder: #{content_folder}"
    if  not File.directory?( content_folder)
      FileUtils.mkdir_p(content_folder)  
    end


  end


  def md_create_master_form(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_form  "
    form_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_form.js" 
    text = File.open(  form_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!(".templatef", ".#{folder_name}f")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}/"  + "Form.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end
  
  def md_create_master_confirm_form(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master confirm form  "
    form_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_confirm_form.js" 
    text = File.open(  form_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!("confirmtemplate", "confirm#{folder_name}")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}/"  + "ConfirmForm.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end
  
  def md_create_master_unconfirm_form(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_form  "
    form_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_unconfirm_form.js" 
    text = File.open(  form_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!("confirmtemplate", "confirm#{folder_name}")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}/"  + "UnconfirmForm.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_master_list(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_list "
    list_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_list.js" 
    text = File.open(  list_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!(".templatel", ".#{folder_name}l")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}/"  + "List.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_master_model(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_model  "
    model_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_model.js" 
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

  def md_create_master_store(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_store  "
    store_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_store.js" 
    text = File.open(  store_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}") 

   

    result_filename = BASE_JS_APP + "/store/"  + "#{entity_name}s.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_master_controller(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master_controller "
    controller_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_controller.js" 
    text = File.open(  controller_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
    first_letter_downcased = entity_name.dup
    
    first_letter_downcased[0] = first_letter_downcased[0].downcase
    
    puts "The first letter_downcased: #{first_letter_downcased}"
   

     
    text.gsub!("Template", "#{entity_name}") 
    text.gsub!("template.template", "#{tab_name}.#{folder_name}") 
    text.gsub!("templatel", "#{folder_name}l") 
    text.gsub!("templatef", "#{folder_name}f") 
    text.gsub!("templated", "#{folder_name}d")
    text.gsub!("templateDetailList", "#{first_letter_downcased}DetailList")  
    text.gsub!("templateP", "#{folder_name}P")  
    text.gsub!("Template", "#{entity_name}")  
    text.gsub!("template_", "#{downcase_merged_entity_name}_")  


   

    result_filename = BASE_JS_APP + "/controller/"  + "#{entity_name}s.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end



  # CREATE DETAIL RELATED

  def md_create_detail_form(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create detail_form  "
    form_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/detail_form.js" 
    text = File.open(  form_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('')   

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!(".templated", ".#{folder_name}d")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}detail/"  + "Form.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_detail_list(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create detail_list  "
    list_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/detail_list.js" 
    text = File.open(  list_template ).read 

   
    folder_name = downcase_tokenized_entity_name.join('') 

   

    text.gsub!("template.template", "#{tab_name}.#{folder_name}")
    text.gsub!(".templated", ".#{folder_name}d")
    text.gsub!("Template", "#{entity_name}")

   

    result_filename = BASE_JS_APP + "/view/#{tab_name}/#{folder_name}detail/"  + "List.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_detail_model(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create detail_model "
    model_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/detail_model.js" 
    text = File.open(    model_template  ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}")

    text.gsub!("template", "#{downcase_merged_entity_name}")

   

    result_filename = BASE_JS_APP + "/model/"  + "#{entity_name}Detail.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_detail_store(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create detail_store  "
    store_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/detail_store.js" 
    text = File.open(  store_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}") 

   

    result_filename = BASE_JS_APP + "/store/"  + "#{entity_name}Details.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_detail_controller(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create detail_controller "
    controller_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/detail_controller.js" 
    text = File.open(  controller_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}") 
    text.gsub!("template.template", "#{tab_name}.#{folder_name}") 
    text.gsub!("templatel", "#{folder_name}l") 
    
    text.gsub!("templated", "#{folder_name}d")   
    text.gsub!("template_", "#{downcase_merged_entity_name}_")    

   

    result_filename = BASE_JS_APP + "/controller/"  + "#{entity_name}Details.js"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end

  def md_create_master_detail_master_server_controller_rb(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create master sever_controller "
    controller_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_detail_master_server_controller.rb" 
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

  def md_create_master_detail_detail_server_controller_rb(tab_name, entity_name, downcase_tokenized_entity_name)
    puts "Create detail server_controller "
    controller_template = "#{BASE_MASTER_DETAIL_TEMPLATE_FOLDER}/master_detail_detail_server_controller.rb" 
    text = File.open(  controller_template ).read 

   
    folder_name = ""
    downcase_tokenized_entity_name.each {|x| folder_name << x }

    downcase_merged_entity_name = downcase_tokenized_entity_name.join("_")
   

     
    text.gsub!("Template", "#{entity_name}") 
    text.gsub!("template_", "#{downcase_merged_entity_name}_") 
    text.gsub!("template", "#{downcase_merged_entity_name}")  


   

    result_filename = BASE_CONTROLLER_FOLDER + "/api/"  + "#{downcase_merged_entity_name}_details_controller.rb"
    File.open(result_filename, 'w') { |file| file.write( text ) }
  end
end
