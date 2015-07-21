class CoreBuilder < ActiveRecord::Base
 
  belongs_to :machine
  belongs_to :uom
  validates_presence_of :uom_id
  validates_presence_of :machine_id
  
  
  validates_uniqueness_of :base_sku
  validates_presence_of :base_sku

  validate :valid_uom_id
  validate :valid_machine_id
  validate :valid_core_builder_type
  
  def valid_uom_id
    return if uom_id.nil? 
    uom = Uom.find_by_id(uom_id)
    if uom.nil? 
      self.errors.add(:uom_id, "Harus ada uom_id")
      return self
    end
  end
  
  def valid_core_builder_type
    return if core_builder_type_case.nil?
    if not [CORE_BUILDER_TYPE[:hollow],CORE_BUILDER_TYPE[:shaft],CORE_BUILDER_TYPE[:none]].include?( core_builder_type_case.to_s) 
    
      self.errors.add(:core_builder_type_case, "CoreBuilder Type harus ada")

      return self 
    end
  end
  
  def valid_machine_id
    return if machine_id.nil? 
    machine = Machine.find_by_id(machine_id)
    if machine.nil? 
      self.errors.add(:machine_id, "Harus ada machine_id")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def used_core_item
    Core.find_by_id(self.used_core_item_id)
  end
  
  def new_core_item
    Core.find_by_id(self.new_core_item_id)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.base_sku = params[:base_sku]
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.uom_id = params[:uom_id]
    new_object.core_builder_type_case = params[:core_builder_type_case]
    new_object.machine_id = params[:machine_id]
    new_object.cd = BigDecimal( params[:cd] || '0') 
    new_object.tl = BigDecimal( params[:tl] || '0') 
    if new_object.save
      # create used core item
      used_core = Core.create_object(
        :sku => new_object.base_sku.to_s + "U",
        :name => new_object.name,
        :description => new_object.description,
        :uom_id => new_object.uom_id
        )
      # create new core item
      new_core = Core.create_object(
        :sku => new_object.base_sku.to_s + "N",
        :name => new_object.name,
        :description => new_object.description,
        :uom_id => new_object.uom_id
        )
      new_object.sku_used_core = used_core.sku
      new_object.sku_new_core = new_core.sku
      new_object.used_core_item_id = used_core.id
      new_object.new_core_item_id = new_core.id
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if RollerBuilder.where(:core_builder_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di RollerBuilder")
      return self 
    end
    if RollerIdentificationFormDetail.where(:core_builder_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di RollerIdentificationForm")
      return self 
    end
    self.base_sku = params[:base_sku]
    self.name = params[:name]
    self.description = params[:description]
    self.uom_id = params[:uom_id]
    self.core_builder_type_case = params[:core_builder_type_case]
    self.machine_id = params[:machine_id]
    self.cd = BigDecimal(params[:cd] || '0')
    self.tl = BigDecimal(params[:tl] || '0')
    if self.save
      self.used_core_item.update_object(
        :name => self.name,
        :description => self.description,
        )
      self.new_core_item.update_object(
        :name => self.name,
        :description => self.description
        )
    end
    return self
  end
  
  def delete_object
    if RollerBuilder.where(:core_builder_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di RollerBuilder")
      return self 
    end
    if RollerIdentificationFormDetail.where(:core_builder_id => self.id).count > 0 
      self.errors.add(:generic_errors, "Sudah terpakai di RollerIdentificationForm")
      return self 
    end
    self.used_core_item.delete_object
    self.new_core_item.delete_object
    self.destroy
    return self
  end
    
    
end
