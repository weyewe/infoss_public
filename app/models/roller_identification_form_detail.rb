class RollerIdentificationFormDetail < ActiveRecord::Base
  belongs_to :roller_identification_form
  belongs_to :machine
  belongs_to :core_builder
  belongs_to :roller_type 
  has_many :roller_accessory_details
  validates_presence_of :roller_identification_form_id
  validates_presence_of :machine_id
  validates_presence_of :core_builder_id
  validates_presence_of :roller_type_id
  validate :valid_roller_identification_form_id
  validate :valid_machine_id
  validate :valid_core_builder_id
  validate :valid_roller_type_id
  
  def self.active_objects
    return self
  end
  
  def active_children
    self.roller_accessory_details  
  end
  
  def valid_roller_identification_form_id
    return if  roller_identification_form_id.nil?
    rif = RollerIdentificationForm.find_by_id roller_identification_form_id
    if rif.nil? 
      self.errors.add(:roller_identification_form_id, "Harus ada RollerIdentificationForm Id")
      return self 
    end
  end  
  
  def valid_machine_id
    return if  machine_id.nil?
    machine = Machine.find_by_id machine_id
    if machine.nil? 
      self.errors.add(:machine_id, "Harus ada Machine Id")
      return self 
    end
  end  
  
  def valid_core_builder_id
    return if  core_builder_id.nil?
    cb = CoreBuilder.find_by_id core_builder_id
    if cb.nil? 
      self.errors.add(:core_builder_id, "Harus ada CoreBuilder Id")
      return self 
    end
  end 
  
  def valid_roller_type_id
    return if  roller_type_id.nil?
    rt = RollerType.find_by_id roller_type_id
    if rt.nil? 
      self.errors.add(:roller_type_id, "Harus ada RollerType Id")
      return self 
    end
  end 
  
  def self.create_object(params)
    new_object = self.new
    new_object.roller_identification_form_id = params[:roller_identification_form_id]
    new_object.material_case = params[:material_case]
    new_object.core_builder_id = params[:core_builder_id]
    new_object.detail_id = params[:detail_id]
    new_object.roller_type_id = params[:roller_type_id]
    new_object.machine_id = params[:machine_id]
    new_object.roller_no = params[:roller_no]
    new_object.repair_request_case = params[:repair_request_case]
    new_object.is_job_scheduled = params[:is_job_scheduled]
    new_object.is_delivered = params[:is_delivered]
    new_object.is_roller_built = params[:is_roller_built]
    new_object.roller_no = params[:roller_no]
    new_object.rd = BigDecimal( params[:rd] || '0')    
    new_object.cd = BigDecimal( params[:cd] || '0')    
    new_object.rl = BigDecimal( params[:rl] || '0')    
    new_object.wl = BigDecimal( params[:wl] || '0')    
    new_object.tl = BigDecimal( params[:tl] || '0')    
    new_object.gl = BigDecimal( params[:gl] || '0')    
    new_object.groove_length = BigDecimal( params[:groove_length] || '0')    
    new_object.groove_amount = BigDecimal( params[:groove_amount] || '0')   
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.roller_identification_form_id = params[:roller_identification_form_id]
    self.detail_id = params[:detail_id]
    self.material_case = params[:material_case]
    self.core_builder_id = params[:core_builder_id]
    self.roller_type_id = params[:roller_type_id]
    self.machine_id = params[:machine_id]
    self.roller_no = params[:roller_no]
    self.repair_request_case = params[:repair_request_case]
    self.is_job_scheduled = params[:is_job_scheduled]
    self.is_delivered = params[:is_delivered]
    self.is_roller_built = params[:is_roller_built]
    self.roller_no = params[:roller_no]
    self.rd = BigDecimal( params[:rd] || '0')    
    self.cd = BigDecimal( params[:cd] || '0')    
    self.rl = BigDecimal( params[:rl] || '0')    
    self.wl = BigDecimal( params[:wl] || '0')    
    self.tl = BigDecimal( params[:tl] || '0')    
    self.gl = BigDecimal( params[:gl] || '0')    
    self.groove_length = BigDecimal( params[:groove_length] || '0')    
    self.groove_amount = BigDecimal( params[:groove_amount] || '0')   
    if self.save
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end
end
