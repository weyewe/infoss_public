class PurchaseInvoiceDetail < ActiveRecord::Base
  
   
  validate :valid_purchase_invoice
  validate :valid_purchase_receival_detail
  validate :valid_amount
  belongs_to :purchase_receival_detail
  belongs_to :purchase_invoice
  
  def self.active_objects
    self
  end
  
  
  def item
    self.purchase_receival_detail.item 
  end
  
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_purchase_invoice
    return if  purchase_invoice_id.nil?
    po = PurchaseInvoice.find_by_id purchase_invoice_id
    if po.nil? 
      self.errors.add(:purchase_invoice_id, "Harus ada PurchaseInvoice_id")
      return self 
    end
  end 
    
  def valid_purchase_receival_detail
    return if  purchase_receival_detail_id.nil?
    prd = PurchaseReceivalDetail.find_by_id purchase_receival_detail_id
    if prd.nil? 
      self.errors.add(:purchase_receival_detail_id, "Harus ada Item_Id")
      return self 
    end
    
    itemcount = PurchaseInvoiceDetail.where(
      :purchase_receival_detail_id => purchase_receival_detail_id,
      :purchase_invoice_id => purchase_invoice_id,
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
    purchase_invoice = PurchaseInvoice.find_by_id(params[:purchase_invoice_id])
    if not purchase_invoice.nil?
      if purchase_invoice.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    
   
    new_object.purchase_invoice_id = params[:purchase_invoice_id]
    new_object.purchase_receival_detail_id = params[:purchase_receival_detail_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    
    if new_object.save
      new_object.price = new_object.purchase_receival_detail.purchase_order_detail.price * new_object.amount
      new_object.code = "PID-" + new_object.id.to_s  
      new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    if self.purchase_invoice.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.purchase_receival_detail_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
      self.price = new_object.purchase_receival_detail.purchase_order_detail.price
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.purchase_invoice.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    self.calculateTotalAmount
    return self
  end
  
  
  def calculateTotalAmount
    amount = 0
    PurchaseInvoiceDetail.where(:purchase_invoice_id =>purchase_invoice_id).each do |pid|
      amount += pid.price
    end
    purchase_invoice = PurchaseInvoice.find_by_id(purchase_invoice_id)
    discount = purchase_invoice.discount / 100 * amount
    taxable_amount = amount - discount
    tax = purchase_invoice.tax / 100 * taxable_amount
    purchase_invoice.amount_payable = taxable_amount + tax 
    purchase_invoice.save
    
  end
  
end
