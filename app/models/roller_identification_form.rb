class RollerIdentificationForm < ActiveRecord::Base
  
  belongs_to :warehouse
  belongs_to :contact
  has_many :roller_identification_form_details
  validates_presence_of :warehouse_id
  validates_presence_of :identified_date
  validate :valid_warehouse_id
  validate :valid_contact_id
  
   
  def self.active_objects
    self
  end
  
  def active_children
    self.roller_identification_form_details 
  end
  
  
  def valid_warehouse_id
    return if  warehouse_id.nil?
    wh = Warehouse.find_by_id warehouse_id
    if wh.nil? 
      self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
      return self 
    end
  end  
  
  def valid_contact_id
    return if contact_id.nil?
    co = Contact.find_by_id contact_id
    if co.nil? 
      self.errors.add(:contact_id, "Harus ada Contact Id")
      return self 
    end
  end
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.warehouse_id = params[:warehouse_id]
    new_object.code = params[:code]
    new_object.contact_id = params[:contact_id]
    new_object.is_in_house = params[:is_in_house]
    new_object.amount = params[:amount]
    new_object.identified_date = params[:identified_date]
    new_object.incoming_roll = params[:incoming_roll]
    new_object.nomor_disasembly = params[:nomor_disasembly]
    if new_object.save
      
    end
    return new_object
  end
  
  def update_object(params)
    self.warehouse_id = params[:warehouse_id]
    self.code = params[:code]
    self.contact_id = params[:contact_id]
    self.is_in_house = params[:is_in_house]
    self.amount = params[:amount]
    self.incoming_roll = params[:incoming_roll]
    self.identified_date = params[:identified_date]
    self.nomor_disasembly = params[:nomor_disasembly]
    if self.save
      
    end
    return self
  end
  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.roller_identification_form_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    if not self.amount == self.roller_identification_form_details.count
      self.errors.add(:generic_errors, "Quantity tidak sama dengan jumlah Core Identification Detail #{self.roller_identification_form_details.count}")
      return self 
    end
    
    # check amount item in warehouse
    if self.is_in_house?
      self.roller_identification_form_details.each do |rifd|
        item_id = 0
        if rifd.material_case == MATERIAL_CASE[:new]
          item_id = rifd.core_builder.new_core_item.item.id
        elsif rifd.material_case == MATERIAL_CASE[:used]
          item_id = rifd.core_builder.used_core_item.item.id
        end
        total_core = 0
        # calculate total_core for same id
        self.roller_identification_form_details.each do |rifdd|
          item_idd = 0
          if rifd.material_case == MATERIAL_CASE[:new]
            item_idd = rifdd.core_builder.new_core_item.item.id
          elsif rifd.material_case == MATERIAL_CASE[:used]
            item_idd = rifdd.core_builder.used_core_item.item.id
          end
          if item_idd == item_id 
            total_core += 1 
          end
        end
        # get item amount in warehouse
        item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => item_id)
        if total_core > item_in_warehouse.amount
          self.errors.add(
            :generic_errors,
            "Stock di warehouseId: #{self.warehouse_id} " + 
            ", itemId: #{item_id}" +
            "jumlah: #{item_in_warehouse.amount} " +
            "tidak mencukupi untuk melakukan Roller Identification")
          return self 
        end
      end
    end
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true
    if self.save
      self.update_rif_confirm
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    
    self.confirmed_at = nil
    self.is_confirmed = false
    if self.save
      self.update_rif_unconfirm
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end
  
  def update_rif_confirm
    if self.is_in_house == false & (not self.contact_id.nil?)
      self.roller_identification_form_details.each do |rifd|
        item_id = 0
        if rifd.material_case == MATERIAL_CASE[:new]
          item_id = rifd.core_builder.new_core_item.item.id
        elsif rifd.material_case == MATERIAL_CASE[:used]
          item_id = rifd.core_builder.used_core_item.item.id
        end
        item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => item_id)
        customer_item = CustomerItem.find_or_create_object(
          :contact_id => self.contact_id,
          :warehouse_item_id => item_in_warehouse.id
          )
        new_stock_mutation = CustomerStockMutation.create_object(
          :source_class => self.class.to_s, 
          :source_id => self.id ,  
          :contact_id => self.contact_id,
          :customer_item_id => customer_item.id,
          :amount => 1,  
          :status => ADJUSTMENT_STATUS[:addition],  
          :mutation_date => self.identified_date ,  
          :warehouse_id => self.warehouse_id ,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => item_id,
          :item_case => ITEM_CASE[:ready],
          :source_code => self.code
          ) 
        new_stock_mutation.stock_mutate_object
      end
    end
  end
  
  def update_rif_unconfirm
    if self.is_in_house == false & (not self.contact_id.nil?)
      self.roller_identification_form_details.each do |rifd|
        item_id = 0
        if rifd.material_case == MATERIAL_CASE[:new]
          item_id = rifd.core_builder.new_core_item.item.id
        elsif rifd.material_case == MATERIAL_CASE[:used]
          item_id = rifd.core_builder.used_core_item.item.id
        end
        item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => item_id)
        customer_item = CustomerItem.find_or_create_object(
          :contact_id => self.contact_id,
          :warehouse_item_id => item_in_warehouse.id
          )
        customer_stock_mutation = CustomerStockMutation.where(
          :source_class => self.class.to_s, 
          :source_id => self.id,
          :contact_id => self.contact_id,
          :customer_item_id => customer_item.id,
          :warehouse_item_id => item_in_warehouse.id,
          :item_id => item_id
          ).first
        customer_stock_mutation.reverse_stock_mutate_object  
        customer_stock_mutation.delete_object
      end
    end
  end
  
end
