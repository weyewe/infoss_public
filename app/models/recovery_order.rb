class RecoveryOrder < ActiveRecord::Base
  belongs_to :roller_identification_form
  belongs_to :warehouse
  has_many :recovery_order_details
  validates_presence_of :roller_identification_form_id
  validates_presence_of :code
  validates_presence_of :warehouse_id
  validate :valid_roller_identification_form_id
  validate :valid_warehouse_id
  
   
  def self.active_objects
    self
  end
  
  def active_children
    self.recovery_order_details 
  end
  
  
  
  def valid_roller_identification_form_id
    return if roller_identification_form_id.nil?
    rif = RollerIdentificationForm.find_by_id roller_identification_form_id
    if rif.nil? 
      self.errors.add(:roller_identification_form_id, "Harus ada RollerIdentificationForm Id")
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
    new_object.roller_identification_form_id = params[:roller_identification_form_id]
    new_object.warehouse_id = params[:warehouse_id]
    new_object.code = params[:code]
    new_object.has_due_date = params[:has_due_date]
    if params[:has_due_date] ==  true
      new_object.due_date = params[:due_date]
    end
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed == true 
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
    if self.recovery_order_details.count > 0 
      self.errors.add(:generic,"Sudah memiliki detail")
      return self
    end
    self.roller_identification_form_id = params[:roller_identification_form_id]
    self.warehouse_id = params[:warehouse_id]
    self.code = params[:code]
    self.has_due_date = params[:has_due_date]
    if params[:has_due_date] ==  true
      self.due_date = params[:due_date]
    else
      self.due_date = nil
    end
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed == true 
      self.errors.add(:generic,"Sudah di confirm")
      return self
    end
    if self.recovery_order_details.count > 0 
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
    if self.recovery_order_details.count == 0 
      self.errors.add(:generic,"Tidak memiliki detail")
      return self
    end
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true
    if self.save
      self.update_recovery_order_confirm
    end
    return self
  end
  
  def unconfirm_object
    if self.is_confirmed == false 
      self.errors.add(:generic,"Belum di confirm")
      return self
    end
    self.confirmed_at = nil
    self.is_confirmed = false
    if self.save
      update_recovery_order_unconfirm
    end
    return self
  end
  
  def update_recovery_order_confirm
    self.recovery_order_details.each do |rod|
      rod.roller_identification_form_detail.is_job_scheduled = true
      rod.roller_identification_form_detail.save
    end
  end
  
  def update_recovery_order_unconfirm
    self.recovery_order_details.each do |rod|
      rod.roller_identification_form_detail.is_job_scheduled = false
      rod.roller_identification_form_detail.save
    end
  end
  
end
