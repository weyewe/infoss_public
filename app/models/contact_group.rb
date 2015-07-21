class ContactGroup < ActiveRecord::Base
  
  has_many :contacts 
  
  validates_presence_of :name 
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.description = params[:description]
    self.save
    return self
  end
  
  def delete_object
    if self.contacts.count != 0
      self.errors.add(:generic_errors, "Sudah ada contact")
      return self 
    end
    
    self.destroy
  end
  
end
