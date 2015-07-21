class Warehouse < ActiveRecord::Base
  has_many :stock_adjustments 
  
  validates_presence_of :name 
  validates_presence_of :code 
  validates_uniqueness_of :code
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.code = params[:code]
    new_object.description = params[:description]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.description = params[:description]
    self.code = params[:code]
    self.save
    return self
  end
  
  def delete_object
    warehouse_id = self.id
     if WarehouseItem.where{
      (warehouse_id == warehouse_id) && 
      (amount.gt 0)
      }.count > 0
      self.errors.add(:generic_errors, "Item diwarehouse harus 0")
      return self
    end
    if RollerIdentificationForm.where(:warehouse_id => self.id).count > 0
      self.errors.add(:generic_errors, "Warehouse sudah terpakai di RollerIdentificationForm")
      return self
    end
    if BlanketOrder.where(:warehouse_id => self.id).count > 0
      self.errors.add(:generic_errors, "Warehouse sudah terpakai di BlanketOrder")
      return self
    end
    self.destroy
  end

end
