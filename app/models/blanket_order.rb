class BlanketOrder < ActiveRecord::Base
  belongs_to :contact
  belongs_to :warehouse
  has_many :blanket_order_details
  
  validates_presence_of :contact_id
  validates_presence_of :warehouse_id
  validates_presence_of :order_date
  validates_presence_of :production_no
  validate :valid_contact_id
  validate :valid_warehouse_id
  
  def self.active_objects
    self
  end
  
  def active_children
    self.blanket_order_details 
  end
  
  
  def valid_contact_id
    return if contact_id.nil?
    
    co = Contact.find_by_id contact_id
    
    if co.nil? 
      self.errors.add(:contact_id, "Harus ada Contact Id")
      return self 
    end
  end
  
  def valid_warehouse_id
    return if warehouse_id.nil?
    
    wh = Warehouse.find_by_id warehouse_id
    
    if wh.nil? 
      self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
      return self 
    end
  end
        
  def self.create_object(params)
    new_object = self.new
    new_object.contact_id = params[:contact_id]
    new_object.order_date = params[:order_date]
    new_object.production_no = params[:production_no]
    new_object.warehouse_id = params[:warehouse_id]
    new_object.has_due_date = params[:has_due_date]
    new_object.amount_received = 0
    new_object.amount_rejected = 0
    new_object.amount_final = 0
    
    if params[:has_due_date] == true
      new_object.due_date = params[:due_date]
    else
      new_object.due_date = nil
    end
    new_object.notes = params[:notes]
    if new_object.save
      new_object.code = "BO-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed == true 
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
    if self.blanket_order_details.count > 0 
      self.errors.add(:generic,"Sudah memiliki detail")
      return self
    end
    self.contact_id = params[:contact_id]
    self.order_date = params[:order_date]
    self.production_no = params[:production_no]
    self.warehouse_id = params[:warehouse_id]
    self.has_due_date = params[:has_due_date]
    if params[:has_due_date] == true
      self.due_date = params[:due_date]
    else
      self.due_date = nil
    end
    self.notes = params[:notes]
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed == true 
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
    if self.blanket_order_details.count > 0 
      self.errors.add(:generic,"Sudah memiliki detail")
      return self
    end
    
    self.destroy
    return self
  end
  
  def confirm_object(params)
    if self.is_confirmed == true 
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
    if self.blanket_order_details.count == 0 
      self.errors.add(:generic,"Tidak memiliki detail")
      return self
    end
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true
    if self.save
    end
  end
  
  def unconfirm_object
    if self.is_confirmed == false 
      self.errors.add(:generic,"Belum di confirm")
      return self
    end
    if BlanketWarehouseMutation.where(:blanket_order_id => self.id).count > 0
      self.errors.add(:generic,"Sudah di pakai di BlanketWarehouseMutation")
      return self
    end
    self.confirmed_at = nil
    self.is_confirmed = false
    if self.save
    end
  end
  
  
end
