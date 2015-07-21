class Uom < ActiveRecord::Base
     
  validates_presence_of :name 
  validates_uniqueness_of :name
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.save
    return self
  end
  
  def delete_object
    if Item.where(:uom_id => self.id).count > 0
      self.errors.add(:generic_errors, "UoM sudah terpakai")
      return self
    end
    self.destroy
  end
  
end
