class TemporaryDeliveryOrder < ActiveRecord::Base
  
  belongs_to :warehouse
  belongs_to :delivery_order
  has_many  :temporary_delivery_order_details
  validates_presence_of :delivery_order_id
  validates_presence_of :nomor_surat
  validates_presence_of :warehouse_id
  validates_presence_of :delivery_date
  
  validate :valid_warehouse_id
  validate :valid_delivery_order_id
  
  def valid_warehouse_id
    return if  warehouse_id.nil?
    wh = Warehouse.find_by_id warehouse_id
    if wh.nil? 
      self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
      return self 
    end
  end

  def valid_delivery_order_id
    return if  delivery_order_id.nil?
    dod = DeliveryOrder.find_by_id delivery_order_id
    if dod.nil? 
      self.errors.add(:delivery_order_id, "Harus ada DeliveryOrder Id")
      return self 
    end
  end    
  
  
  def self.active_objects
    self
  end
  
  def active_children
    self.temporary_delivery_order_details
  end
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.nomor_surat = params[:nomor_surat]
    new_object.order_type = ORDER_TYPE_CASE[:part_delivery_order]
    new_object.delivery_order_id = params[:delivery_order_id]
    new_object.warehouse_id = params[:warehouse_id]
    new_object.delivery_date = params[:delivery_date]
    if new_object.save  
    new_object.code = "TDO-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.temporary_delivery_order_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.nomor_surat = params[:nomor_surat]
#     self.order_type = params[:order_type]
    self.delivery_order_id = params[:delivery_order_id]
    self.warehouse_id = params[:warehouse_id]
    self.delivery_date = params[:delivery_date]
    self.save
    return self
  end
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.temporary_delivery_order_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.destroy
  end

  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.temporary_delivery_order_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    # check sales_order_detail pending_delivery_amount
    self.temporary_delivery_order_details.each do |tdod|
      if tdod.sales_order_detail.pending_delivery_amount < tdod.amount
        self.errors.add(:generic_errors, "Pending Delivery Amount < TemporaryDeliveryOrderDetail amount")
        return self
      end
    end
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_temporary_delivery_order_confirm
    end
    return self
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.update_temporary_delivery_order_unconfirm
    end
    return self
  end
  
  def update_temporary_delivery_order_confirm 
    self.temporary_delivery_order_details.each do |tdod|
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => tdod.amount ,  
        :status => ADJUSTMENT_STATUS[:addition],  
        :mutation_date => self.delivery_date ,  
        :item_id => tdod.item_id,
        :item_case => ITEM_CASE[:virtual],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
      tdod.sales_order_detail.pending_delivery_amount -= tdod.amount    
      if tdod.sales_order_detail.pending_delivery_amount == 0 
        tdod.sales_order_detail.is_all_delivered == true
      end
      tdod.sales_order_detail.save
    end
  end
  
  def update_temporary_delivery_order_unconfirm 
    self.temporary_delivery_order_details.each do |tdod|
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :item_id => tdod.item_id
        )
      stock_mutation.each do |sm|
        sm.reverse_stock_mutate_object  
        sm.delete_object
      end
      tdod.sales_order_detail.pending_delivery_amount += tdod.amount
      tdod.sales_order_detail.is_all_delivered == false
      tdod.sales_order_detail.save
    end
  end
  
  
end
