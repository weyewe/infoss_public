class RollerBuilder < ActiveRecord::Base
    
  belongs_to :machine
  belongs_to :roller_type
  belongs_to :core_builder
  belongs_to :uom
  validates_presence_of :uom_id
  validates_presence_of :machine_id
  validates_presence_of :adhesive_id
  validates_presence_of :roller_type_id
  validates_presence_of :compound_id
  validates_presence_of :core_builder_id
  validates_uniqueness_of :base_sku
  validates_presence_of :base_sku
  
  validate :valid_uom_id
  validate :valid_machine_id
  validate :valid_adhesive_id
  validate :valid_roller_type_id
  validate :valid_compound_id
  validate :valid_core_builder_id
  
  def valid_uom_id
    return if uom_id.nil? 
    uom = Uom.find_by_id(uom_id)
    if uom.nil? 
      self.errors.add(:uom_id, "Harus ada uom_id")
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
  
  def valid_core_builder_id
    return if core_builder_id.nil? 
    core_builder = CoreBuilder.find_by_id(core_builder_id)
    if core_builder.nil? 
      self.errors.add(:core_builder_id, "Harus ada core_builder_id")
      return self
    end
  end
  
  def valid_roller_type_id
    return if roller_type_id.nil? 
    roller_type = RollerType.find_by_id(roller_type_id)
    if roller_type.nil? 
      self.errors.add(:roller_type_id, "Harus ada roller_type_id")
      return self
    end
  end
  
  def valid_adhesive_id
    return if adhesive_id.nil? 
    adhesive = Item.find_by_id(adhesive_id)
    if adhesive.nil?
        self.errors.add(:adhesive_id, "Adhesive tidak valid")
        return self
    else
      if not adhesive.item_type.name == ITEM_TYPE_CASE[:AdhesiveRoller]
        self.errors.add(:adhesive_id, "Adhesive tidak valid")
        return self
      end
    end
  end
  
  def valid_compound_id
    return if compound_id.nil? 
    compound = Item.find_by_id(compound_id)
    if compound.nil?
        self.errors.add(:compound_id, "compound_id tidak valid")
        return self
    else
      if not compound.item_type.name == ITEM_TYPE_CASE[:Compound]
        self.errors.add(:compound_id, "compound_id tidak valid")
        return self
      end
    end
  end
  
  def self.active_objects
    self
  end
  
  def roller_used_core_item
    Roller.find_by_id(self.roller_used_core_item_id)
  end
  
  def roller_new_core_item
    Roller.find_by_id(self.roller_new_core_item_id)
  end
  
  def adhesive
    Item.find_by_id(self.adhesive_id)
  end
  
  def compound
    Item.find_by_id(self.compound_id)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.base_sku = params[:base_sku]
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.uom_id = params[:uom_id]
    new_object.adhesive_id = params[:adhesive_id]
    new_object.compound_id = params[:compound_id]
    new_object.machine_id = params[:machine_id]
    new_object.roller_type_id = params[:roller_type_id]
    new_object.core_builder_id = params[:core_builder_id]
    new_object.is_grooving = params[:is_grooving]
    new_object.is_crowning = params[:is_crowning]
    new_object.is_chamfer = params[:is_chamfer]
    new_object.crowning_size = BigDecimal( params[:crowning_size] || '0') 
    new_object.grooving_width =BigDecimal( params[:grooving_width] || '0') 
    new_object.grooving_depth = BigDecimal( params[:grooving_depth] || '0') 
    new_object.grooving_position = BigDecimal( params[:grooving_position] || '0') 
    new_object.cd = BigDecimal( params[:cd] || '0') 
    new_object.rd = BigDecimal( params[:rd] || '0') 
    new_object.rl = BigDecimal( params[:rl] || '0') 
    new_object.wl = BigDecimal( params[:wl] || '0') 
    new_object.tl = BigDecimal( params[:tl] || '0') 
    if new_object.save
      # create used core item
      roller_used_core = Roller.create_object(
        :sku => new_object.base_sku.to_s + "U",
        :name => new_object.name,
        :description => new_object.description,
        :uom_id => new_object.uom_id
        )
      # create new core item
      roller_new_core = Roller.create_object(
        :sku => new_object.base_sku.to_s + "N",
        :name => new_object.name,
        :description => new_object.description,
        :uom_id => new_object.uom_id
        )
      new_object.sku_roller_used_core = roller_used_core.sku
      new_object.sku_roller_new_core = roller_new_core.sku
      new_object.roller_used_core_item_id = roller_used_core.id
      new_object.roller_new_core_item_id = roller_new_core.id
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if RecoveryOrderDetail.where(:roller_builder_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di RecoveryOrderDetail")
      return self
    end
    self.base_sku = params[:base_sku]
    self.name = params[:name]
    self.description = params[:description]
    self.uom_id = params[:uom_id]
    self.adhesive_id = params[:adhesive_id]
    self.compound_id = params[:compound_id]
    self.machine_id = params[:machine_id]
    self.roller_type_id = params[:roller_type_id]
    self.core_builder_id = params[:core_builder_id]
    self.is_grooving = params[:is_grooving]
    self.is_crowning = params[:is_crowning]
    self.is_chamfer = params[:is_chamfer]
    self.crowning_size = BigDecimal( params[:crowning_size] || '0') 
    self.grooving_width =BigDecimal( params[:grooving_width] || '0') 
    self.grooving_depth = BigDecimal( params[:grooving_depth] || '0') 
    self.grooving_position = BigDecimal( params[:grooving_position] || '0') 
    self.cd = BigDecimal( params[:cd] || '0') 
    self.rd = BigDecimal( params[:rd] || '0') 
    self.rl = BigDecimal( params[:rl] || '0') 
    self.wl = BigDecimal( params[:wl] || '0') 
    self.tl = BigDecimal( params[:tl] || '0') 
    if self.save
      self.roller_used_core_item.update_object(
        :name => self.name,
        :description => self.description,
        )
      self.roller_new_core_item.update_object(
        :name => self.name,
        :description => self.description
        )
    end
    return self
  end
  
  def delete_object
    if RecoveryOrderDetail.where(:roller_builder_id => self.id).count > 0
      self.errors.add(:generic_errors, "Sudah terpakai di RecoveryOrderDetail")
      return self
    end
    self.roller_used_core_item.delete_object
    self.roller_new_core_item.delete_object
    self.destroy
    return self
  end
  
  def compound
    Item.find_by_id self.compound_id
  end
    
    
end
