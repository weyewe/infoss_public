class VirtualOrderDetail < ActiveRecord::Base
  validates_presence_of :item_id
  belongs_to :item
  validate :valid_virtual_order
  validate :valid_item
  validate :valid_amount
  belongs_to :virtual_order
  
  def self.active_objects
    self
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_virtual_order
    return if  virtual_order_id.nil?
    po = VirtualOrder.find_by_id virtual_order_id
    if po.nil? 
      self.errors.add(:virtual_order_id, "Harus ada VirtualOrder_id")
      return self 
    end
  end 
    
  def valid_item
    return if  item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item_Id")
      return self 
    end
    
    itemcount = VirtualOrderDetail.where(
      :item_id => item_id,
      :virtual_order_id => virtual_order_id,
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
    virtual_order = VirtualOrder.find_by_id(params[:virtual_order_id])
    if not virtual_order.nil?
      if virtual_order.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.virtual_order_id = params[:virtual_order_id]
    new_object.item_id = params[:item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.pending_delivery_amount = BigDecimal( params[:amount] || '0')
    new_object.price = BigDecimal( params[:price] || '0')
    if new_object.save
      new_object.code = "VOD-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.virtual_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.item_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0')
    self.pending_delivery_amount = BigDecimal( params[:amount] || '0')
    self.price = BigDecimal( params[:price] || '0')
    self.save
    return self
  end
  
  def delete_object
    if self.virtual_order.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
  
  
end
