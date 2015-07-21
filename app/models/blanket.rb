class Blanket < ActiveRecord::Base
  acts_as :item
  
  belongs_to :contact
  belongs_to :machine
  
  validates_presence_of :contact_id
  validates_presence_of :machine_id
  validates_presence_of :roll_blanket_item_id
  
  validate :valid_contact_id
  validate :valid_machine_id
  validate :valid_roll_blanket_item_id
  validate :valid_adhesive
  validate :valid_left_bar_and_right_bar
  validate :valid_cropping_type
  validate :valid_application_case
  
  
  
  def self.active_objects
    self
  end
  
  def valid_cropping_type
    return if cropping_type.nil? 
    if not [CROPPING_TYPE[:normal],CROPPING_TYPE[:special], CROPPING_TYPE[:none]].include?( cropping_type) 
      self.errors.add(:cropping_type, "Cropping Type harus ada")
 
      return self 
    end
  end
  
  def valid_application_case
    return if application_case.nil?
 
    if not [APPLICATION_CASE[:web],APPLICATION_CASE[:sheetfed],APPLICATION_CASE[:both]].include?( application_case.to_i) 
      self.errors.add(:application_case, "Application Type harus ada")
 
      return self 
    end
  end
  
  def valid_contact_id
    return if contact_id.nil? 
    contact = Contact.find_by_id(contact_id)
    if contact.nil? 
      self.errors.add(:contact_id, "Harus ada contact_id")
      return self
    end
  end
  
  def valid_left_bar_and_right_bar
    if is_bar_required == true
      if not left_bar_item_id.nil?
        left_bar_item = Item.find_by_id(left_bar_item_id)
        if left_bar_item.nil?
          self.errors.add(:left_bar_item_id, "LeftBar tidak valid")
          return self
        else
          if not left_bar_item.item_type.name == ITEM_TYPE_CASE[:Bar]
            self.errors.add(:left_bar_item_id, "LeftBar tidak valid")
            return self
          end
        end
      end
      if not right_bar_item_id.nil?
        right_bar_item = Item.find_by_id(right_bar_item_id)
        if right_bar_item.nil?
          self.errors.add(:right_bar_item_id, "RightBar tidak valid")
          return self
        else
          if not right_bar_item.item_type.name == ITEM_TYPE_CASE[:Bar]
            self.errors.add(:right_bar_item_id, "RightBar tidak valid")
            return self
          end
        end
      end
    end
  end
  
  def valid_adhesive
    if not adhesive_id == 0  
      adhesive = Item.find_by_id(adhesive_id)
      if adhesive.nil?
        self.errors.add(:adhesive_id, "Adhesive tidak valid")
        return self
      else
        if not adhesive.item_type.name == ITEM_TYPE_CASE[:AdhesiveBlanket]
          self.errors.add(:adhesive_id, "Adhesive tidak valid")
          return self
        end
      end
    end
    if not adhesive2_id == 0  
      adhesive2 = Item.find_by_id(adhesive2_id)
      if adhesive2.nil?
        self.errors.add(:adhesive2_id, "Adhesive tidak valid")
        return self
      else
        if not adhesive2.item_type.name == ITEM_TYPE_CASE[:AdhesiveBlanket]
          self.errors.add(:adhesive2_id, "Adhesive tidak valid")
          return self
        end
      end
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
  
  def valid_roll_blanket_item_id
    return if roll_blanket_item_id.nil? 
    roll_blanket = Item.find_by_id(roll_blanket_item_id)
    if roll_blanket.nil? 
      self.errors.add(:roll_blanket_item_id, "Harus ada roll_blanket_item_id")
      return self
    else
      if not roll_blanket.item_type.name == ITEM_TYPE_CASE[:RollBlanket]
        self.errors.add(:roll_blanket_item_id, "Roll Blanket tidak valid")
        return self
      end
    end
  end
    
  def self.active_objects
    self
  end
  
  def roll_blanket_item
    Item.find_by_id(self.roll_blanket_item_id)
  end
  
  def adhesive
    Item.find_by_id(self.adhesive_id)
  end
  
  def adhesive2
    Item.find_by_id(self.adhesive2_id)
  end
  
  def left_bar_item
    Item.find_by_id(self.left_bar_item_id)
  end
  
  def right_bar_item
    Item.find_by_id(self.right_bar_item_id)
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.sku = params[:sku]
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.item_type_id = ItemType.find_by_name(ITEM_TYPE_CASE[:Blanket]).id
    new_object.uom_id = params[:uom_id]
    # new_object.minimum_amount =  BigDecimal( params[:minimum_amount] || '0') 
    # new_object.selling_price =  BigDecimal( params[:selling_price] || '0') 
    # new_object.exchange_id = params[:exchange_id]
    # new_object.price_list =  BigDecimal( params[:price_list] || '0') 
    new_object.roll_no = params[:roll_no]
    new_object.contact_id = params[:contact_id]
    new_object.machine_id = params[:machine_id]
    new_object.adhesive_id = params[:adhesive_id]
    new_object.adhesive2_id = params[:adhesive2_id]
    new_object.roll_blanket_item_id = params[:roll_blanket_item_id]
    new_object.left_bar_item_id = params[:left_bar_item_id]
    new_object.right_bar_item_id = params[:right_bar_item_id]
    new_object.ac = BigDecimal(params[:ac] || '0')
    new_object.ar = BigDecimal(params[:ar] || '0')
    new_object.thickness = BigDecimal(params[:thickness] || '0')
    # new_object.ks = BigDecimal(params[:ks] || '0')
    new_object.is_bar_required = params[:is_bar_required]
    if params[:is_bar_required] == true
      if not params[:left_bar_item_id].nil?
        new_object.has_left_bar = true
      else
        new_object.has_left_bar = false
      end
      if not params[:right_bar_item_id].nil?
        new_object.has_right_bar = true
      else
        new_object.has_right_bar = false
      end
    end
    new_object.is_bar_required = params[:is_bar_required]
    new_object.cropping_type = params[:cropping_type]
    new_object.special = params[:special]
    new_object.application_case = params[:application_case]
    new_object.left_over_ac = BigDecimal(params[:left_over_ac] || '0')
    new_object.left_over_ar = BigDecimal(params[:left_over_ar] || '0')
    new_object.minimum_amount = BigDecimal('1')  
    new_object.selling_price = BigDecimal('1')  
    new_object.price_list = BigDecimal('1')  
    new_object.exchange_id = Exchange.where(:is_base => true).first.id
    if new_object.save
    
    end
    return new_object
  end
  
  def update_object(params)
    self.sku = params[:sku]
    self.name = params[:name]
    self.description = params[:description]
    # self.minimum_amount =  BigDecimal( params[:minimum_amount] || '0') 
    # self.selling_price =  BigDecimal( params[:selling_price] || '0') 
    # self.exchange_id = params[:exchange_id]
    # self.price_list =  BigDecimal( params[:price_list] || '0') 
    self.uom_id = params[:uom_id]
    self.roll_no = params[:roll_no]
    self.contact_id = params[:contact_id]
    self.machine_id = params[:machine_id]
    self.adhesive_id = params[:adhesive_id]
    self.adhesive2_id = params[:adhesive2_id]
    self.roll_blanket_item_id = params[:roll_blanket_item_id]
    self.left_bar_item_id = params[:left_bar_item_id]
    self.right_bar_item_id = params[:right_bar_item_id]
    self.ac = BigDecimal(params[:ac] || '0')
    self.ar = BigDecimal(params[:ar] || '0')
    self.thickness = BigDecimal(params[:thickness] || '0')
    # self.ks = BigDecimal(params[:ks] || '0')
    self.is_bar_required = params[:is_bar_required]
    if params[:is_bar_required] == true
      if not params[:left_bar_item_id].nil?
        self.has_left_bar = true
      else
        self.has_left_bar = false
      end
      if not params[:right_bar_item_id].nil?
        self.has_right_bar = true
      else
        self.has_right_bar = false
      end
    end
    self.cropping_type = params[:cropping_type]
    self.special = params[:special]
    self.application_case = params[:application_case]
    self.left_over_ac = BigDecimal(params[:left_over_ac] || '0')
    self.left_over_ar = BigDecimal(params[:left_over_ar] || '0')
    self.save
    return self
  end
  
  def delete_object
    # check if used on blanket order
    if BlanketOrderDetail.where(:blanket_id => self.id).count > 0
      self.errors.add(:generic,"Sudah di gunakan di BlanketOrder")
      return self
    end
    self.destroy
    return self
  end
    
end
