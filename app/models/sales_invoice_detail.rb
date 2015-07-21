class SalesInvoiceDetail < ActiveRecord::Base
  
    
  validate :valid_sales_invoice
  validate :valid_delivery_order_detail
  validate :valid_amount
  belongs_to :delivery_order_detail
  belongs_to :sales_invoice
  # belongs_to :item
  
  def self.active_objects
    self
  end
  
  def item
    self.delivery_order_detail.item
  end
  
  def valid_amount
    if amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus lebih besar dari 0")
      return self
    end
  end
  
  def valid_sales_invoice
    return if  sales_invoice_id.nil?
    po = SalesInvoice.find_by_id sales_invoice_id
    if po.nil? 
      self.errors.add(:sales_invoice_id, "Harus ada SalesInvoice_id")
      return self 
    end
  end 
    
  def valid_delivery_order_detail
    return if  delivery_order_detail_id.nil?
    prd = DeliveryOrderDetail.find_by_id delivery_order_detail_id
    if prd.nil? 
      self.errors.add(:delivery_order_detail_id, "Harus ada Item_Id")
      return self 
    end
    
    itemcount = SalesInvoiceDetail.where(
      :delivery_order_detail_id => delivery_order_detail_id,
      :sales_invoice_id => sales_invoice_id,
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
    sales_invoice = SalesInvoice.find_by_id(params[:sales_invoice_id])
    if not sales_invoice.nil?
      if sales_invoice.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    
    
    new_object.sales_invoice_id = params[:sales_invoice_id]
    new_object.delivery_order_detail_id = params[:delivery_order_detail_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    
    if new_object.save
      new_object.price = (new_object.delivery_order_detail.sales_order_detail.price * new_object.amount).round(2)
      new_object.code = "SID-" + new_object.id.to_s  
      new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    if self.sales_invoice.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.delivery_order_detail_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
      self.price = (new_object.delivery_order_detail.purchase_order_detail.price * self.amount).round(2)
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.sales_invoice.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    self.calculateTotalAmount
    return self
  end
  
  
  def calculateTotalAmount
    amount = 0
    SalesInvoiceDetail.where(:sales_invoice_id =>sales_invoice_id).each do |sid|
      amount += sid.price
    end
    sales_invoice = SalesInvoice.find_by_id(sales_invoice_id)
    discount = sales_invoice.discount / 100 * amount
    taxable_amount = amount - discount
    tax = sales_invoice.tax / 100 * taxable_amount
    sales_invoice.dpp = taxable_amount
    sales_invoice.amount_receivable = taxable_amount + tax 
    sales_invoice.save
    # SalesInvoice.find_by_id(sales_invoice_id).update_amount_receivable(amount)
  end
  
end
  
