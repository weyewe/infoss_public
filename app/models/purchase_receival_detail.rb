class PurchaseReceivalDetail < ActiveRecord::Base
  
  validates_presence_of :purchase_order_detail_id
 
  validate :valid_purchase_receival
  validate :valid_purchase_order_detail
  validate :valid_amount
  belongs_to :purchase_receival
  belongs_to :purchase_order_detail
  belongs_to :item
  def self.active_objects
    self
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_purchase_receival
    return if  purchase_receival_id.nil?
    pr = PurchaseReceival.find_by_id purchase_receival_id
    if pr.nil? 
      self.errors.add(:purchase_receival_id, "Harus ada purchase_receival_id")
      return self 
    end
  end 
    
  def valid_purchase_order_detail
    return if  purchase_order_detail_id.nil?
    pod = PurchaseOrderDetail.find_by_id purchase_order_detail_id
    if pod.nil? 
      self.errors.add(:item_id, "Harus ada purchase_order_detail_id")
      return self 
    end
    
    itemcount = PurchaseReceivalDetail.where(
      :purchase_order_detail_id => purchase_order_detail_id,
      :purchase_receival_id => purchase_receival_id,
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
    purchase_receival = PurchaseReceival.find_by_id(params[:purchase_receival_id])
    if not purchase_receival.nil?
      if purchase_receival.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    
    new_object.purchase_receival_id = params[:purchase_receival_id]
    new_object.purchase_order_detail_id = params[:purchase_order_detail_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.pending_invoiced_amount = BigDecimal( params[:amount] || '0')
    if new_object.save
      new_object.code = "PRED-" + new_object.id.to_s  
      new_object.item_id = new_object.purchase_order_detail.item_id
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.purchase_receival.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.purchase_receival_id = params[:purchase_receival_id]
    self.purchase_order_detail_id = params[:purchase_order_detail_id]
    self.amount = BigDecimal( params[:amount] || '0')
    self.pending_invoiced_amount = BigDecimal( params[:amount] || '0')
    if self.save
       self.item_id = self.purchase_order_detail.item_id
    end
    return self
  end
  
  def delete_object
    if self.purchase_receival.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
end
