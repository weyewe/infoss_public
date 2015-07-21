class RollerAccessoryDetail < ActiveRecord::Base
  belongs_to :roller_identification_form_detail
  belongs_to :item
  validates_presence_of :roller_identification_form_detail_id
  validates_presence_of :item_id
  validates_presence_of :amount
  validate :valid_roller_identification_form_detail_id
  validate :valid_item_id
  validate :valid_amount
  
  def valid_amount
    if amount <= 0
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_roller_identification_form_detail_id
    return if  roller_identification_form_detail_id.nil?
    rifd = RollerIdentificationFormDetail.find_by_id roller_identification_form_detail_id
    if rifd.nil? 
      self.errors.add(:sales_order_id, "Harus ada RollerIdentificationFormDetail Id")
      return self 
    end
  end 
  
  def valid_item_id
    return if  item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item_Id")
      return self 
    end
    
    if not item.item_type.name == ITEM_TYPE_CASE[:Accessory]
      self.errors.add(:item_id, "Item bukan accesory")
      return self 
    end
    
    itemcount = RollerAccessoryDetail.where(
      :item_id => item_id,
      :roller_identification_form_detail_id => roller_identification_form_detail_id,
      ).count  
    
    if self.persisted?
       if itemcount > 1
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    else
       if itemcount > 0
         self.errors.add(:item_id, "Item sudah terpakai")
      return self 
       end
    end
  end 
  
  def self.create_object(params)
    new_object = self.new
    new_object.item_id = params[:item_id]
    new_object.roller_identification_form_detail_id = params[:roller_identification_form_detail_id]
    new_object.amount = params[:amount]
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    self.item_id = params[:item_id]
    self.roller_identification_form_detail_id = params[:roller_identification_form_detail_id]
    self.amount = params[:amount]
    if self.save
    end
    return self
  end
  
  def delete_object
    self.destroy
    return self
  end
    
end
