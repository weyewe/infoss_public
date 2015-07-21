class CustomerStockMutation < ActiveRecord::Base
    
  belongs_to :contact
  belongs_to :customer_item
  belongs_to :warehouse
  belongs_to :warehouse_item
  belongs_to :item
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new 
    new_object.source_class = params[:source_class]
    new_object.source_id = params[:source_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    new_object.status = params[:status]
    new_object.mutation_date = params[:mutation_date]
    new_object.contact_id = params[:contact_id] 
    new_object.customer_item_id = params[:customer_item_id] 
    new_object.warehouse_id = params[:warehouse_id] 
    new_object.warehouse_item_id = params[:warehouse_item_id]
    new_object.source_code = params[:source_code]
    new_object.item_case = params[:item_case]
    new_object.item_id = params[:item_id]
    new_object.save 
    return new_object 
  end
   
  def stock_mutate_object()
    amount = 0
    if self.status == ADJUSTMENT_STATUS[:addition]
      amount = self.amount 
    else
      amount = self.amount * -1
    end
       
    if self.item_case == ITEM_CASE[:ready] 
      # update item customer_amount
     self.item.update_customer_amount(amount)
      # update warehouse_item customer_amount
     if not self.warehouse_item.nil?
      self.warehouse_item.update_customer_amount(amount)
     end
    # update customer_item amount
     self.customer_item.update_amount(amount)
    elsif self.item_case == ITEM_CASE[:pending_receival]
      self.item.update_pending_receival(amount)
    elsif self.item_case == ITEM_CASE[:pending_delivery]
      self.item.update_pending_delivery(amount)
    # elsif self.item_case == ITEM_CASE[:virtual]
    #   self.item.update_virtual(amount)
    end
  end
  
  def reverse_stock_mutate_object()
    amount = 0
    if self.status == ADJUSTMENT_STATUS[:addition]
      amount = self.amount * -1
    else
      amount = self.amount
    end
    
    if self.item_case == ITEM_CASE[:ready] 
       # update item customer_amount
     self.item.update_customer_amount(amount)
      # update warehouse_item customer_amount
     if not self.warehouse_item.nil?
      self.warehouse_item.update_customer_amount(amount)
     end
    # update customer_item amount
     self.customer_item.update_amount(amount)
    elsif self.item_case == ITEM_CASE[:pending_receival]
      self.item.update_pending_receival(amount)
    elsif self.item_case == ITEM_CASE[:pending_delivery]
      self.item.update_pending_delivery(amount)
    # elsif self.item_case == ITEM_CASE[:virtual]
    #   self.item.update_virtual(amount)
    end
    
  end
  
  def delete_object
    self.destroy
  end
end
