class PurchaseReceival < ActiveRecord::Base
  
  belongs_to :purchase_order
  belongs_to :warehouse 
  has_many :purchase_receival_details
  validates_presence_of :purchase_order_id
  validates_presence_of :nomor_surat
  validates_presence_of :warehouse_id
  validates_presence_of :receival_date
  
  validate :valid_warehouse_id
  validate :valid_purchase_order_id
  
  
  def self.active_objects
    self
  end
  
  def active_children
    self.purchase_receival_details 
  end
  
  def valid_warehouse_id
    return if  warehouse_id.nil?
    wh = Warehouse.find_by_id warehouse_id
    if wh.nil? 
      self.errors.add(:warehouse_id, "Harus ada Warehouse Id")
      return self 
    end
  end

  def valid_purchase_order_id
    return if  purchase_order_id.nil?
    po = PurchaseOrder.find_by_id purchase_order_id
    if po.nil? 
      self.errors.add(:purchase_order_id, "Harus ada PurchaseOrder Id")
      return self 
    end
  end    
  
  def self.create_object( params )
    new_object = self.new
    new_object.warehouse_id = params[:warehouse_id]
    new_object.receival_date = params[:receival_date]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.purchase_order_id = params[:purchase_order_id]
    new_object.save
    new_object.code = "PRE-" + new_object.id.to_s  
    new_object.save
    
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.purchase_receival_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.warehouse_id = params[:warehouse_id]
    self.receival_date = params[:receival_date]
    self.nomor_surat = params[:nomor_surat]
    self.purchase_order_id = params[:purchase_order_id]
    self.save 
    return self
  end
    
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.purchase_receival_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    if Closing.is_date_closed(self.receival_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    if self.purchase_order.exchange.is_base == false 
      latest_exchange_rate = ExchangeRate.get_latest(
        :ex_rate_date => self.receival_date,
        :exchange_id => self.purchase_order.exchange_id
        )
      self.exchange_rate_amount = latest_exchange_rate.rate
      self.exchange_rate_id =  latest_exchange_rate.id   
    else
      self.exchange_rate_amount = 1
    end
    
    
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_purchase_receival_confirm    
      AccountingService::CreatePurchaseReceivalJournal.create_confirmation_journal(self)
    end
    return self 
  end
  
  def unconfirm_object
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    if Closing.is_date_closed(self.receival_date).count > 0 
      self.errors.add(:generic_errors, "Period sudah di closing")
      return self 
    end
    item_id_list = self.purchase_receival_details.map{|x| x.item_id  } 
    if BatchSourceAllocation.joins(:batch_source).where{
      batch_sources.item_id.in item_id_list
    }.count != 0 
      self.errors.add(:generic_errors , "Sudah ada peng-alokasian batch")
      return self 
    end
    
    self.is_confirmed = false
    self.confirmed_at = nil 
    if self.save
      self.update_purchase_receival_unconfirm
      AccountingService::CreatePurchaseReceivalJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
   
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.purchase_receival_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def update_purchase_receival_confirm
    total_cogs = 0
    total_amount = 0
    self.purchase_receival_details.each do |prd|
#       Update Item PendingReceival
      
      item_price = (self.exchange_rate_amount * prd.purchase_order_detail.price).round(2)    
      prd.item.calculate_avg_price(:added_amount => prd.amount,:added_avg_price => item_price)
      
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => prd.amount ,  
        :status => ADJUSTMENT_STATUS[:deduction],  
        :mutation_date => self.receival_date ,  
        :item_id => prd.item_id,
        :item_case => ITEM_CASE[:pending_receival],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
                 
#       Update WarehouseItem Amount
      item_in_warehouse = WarehouseItem.find_or_create_object(:warehouse_id => self.warehouse_id,:item_id => prd.item_id)      
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => prd.amount ,  
        :status => ADJUSTMENT_STATUS[:addition],  
        :mutation_date => self.receival_date ,  
        :warehouse_id => self.warehouse_id ,
        :warehouse_item_id => item_in_warehouse.id,
        :item_id => prd.item_id,
        :item_case => ITEM_CASE[:ready],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
      
      prd.reload
#       set detail cogs
      prd.cogs = prd.item.avg_price * prd.amount
     
#       set detail purchase_order,pending_receival_amount
      prd.purchase_order_detail.pending_receival_amount -= prd.amount    
      if prd.purchase_order_detail.pending_receival_amount == 0 
        prd.purchase_order_detail.is_all_received == true
      end
      prd.purchase_order_detail.save
      prd.save    
      total_cogs += prd.cogs
      total_amount += (prd.purchase_order_detail.price * prd.purchase_order_detail.amount)
      
        
        if prd.item.is_batched?
          BatchSource.create_object( 
            :item_id  => prd.item_id,
            :status   =>  ADJUSTMENT_STATUS[:addition], 
            :source_class => prd.class.to_s, 
            :source_id => prd.id , 
            :generated_date => self.confirmed_at , 
            :amount => prd.amount 
          )
        end
    end
    
    self.total_cogs = total_cogs
    self.total_amount = total_amount
    self.save
    self.purchase_order.update_is_receival_completed
  end
  
  def update_purchase_receival_unconfirm
    self.purchase_receival_details.each do |prd|
      
      amount = prd.amount * -1
      item_price = (self.exchange_rate_amount * prd.purchase_order_detail.price).round(2)    
      prd.item.calculate_avg_price(:added_amount => (amount),:added_avg_price => item_price)
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :item_id => prd.item_id
        )
      stock_mutation.each do |sm|
        sm.reverse_stock_mutate_object  
        sm.delete_object
      end
    
#       set detail cogs
      prd.cogs = 0
#       set detail purchase_order,pending_receival_amount
      prd.purchase_order_detail.pending_receival_amount += prd.amount
      prd.purchase_order_detail.is_all_received == false
      prd.purchase_order_detail.save
      prd.save
      
      
      if prd.item.is_batched?
        BatchSource.where( 
          :source_class => prd.class.to_s, 
          :source_id => prd.id 
        ).each {|x| x.delete_object } 
      end
      
    end
    self.total_cogs = 0
    self.total_amount = 0
    self.save
    self.purchase_order.update_is_receival_completed
  end
  
  def update_is_invoice_completed
    if self.purchase_receival_details.where{(pending_invoiced_amount.gt 0)}.count == 0
      self.is_invoice_completed = true
    else
      self.is_invoice_completed = false
    end    
    self.save
  end
end
