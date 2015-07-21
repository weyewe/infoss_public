class Employee < ActiveRecord::Base
  
  validates_presence_of :name 
  
  def self.active_objects
    self
  end
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.contact_no = params[:contact_no]
    new_object.address = params[:address]
    new_object.email = params[:email]
    new_object.description = params[:description]
    
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.contact_no = params[:contact_no]
    self.address = params[:address]
    self.email = params[:email]
    self.description = params[:description]
    self.save
    return self
  end
  
  def delete_object
    if SalesOrder.where(:employee_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di SalesOrder")
      return self
    end
     if VirtualOrder.where(:employee_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di VirtualOrder")
      return self
    end
    self.destroy
  end
  
  
  
end
