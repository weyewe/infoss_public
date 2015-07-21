class VirtualOrder < ActiveRecord::Base
  belongs_to :contact
  belongs_to :exchange
  belongs_to :employee
  has_many :virtual_order_details
  validates_presence_of :contact_id
  validates_presence_of :employee_id
  validates_presence_of :exchange_id
  validates_presence_of :nomor_surat
  validates_presence_of :order_date
 
  
  validate :valid_contact_id
  validate :valid_exchange_id
  validate :valid_employee_id
  
  def self.active_objects
    self
  end
  
  def active_children
    self.virtual_order_details 
  end
  
  def valid_contact_id
    return if  contact_id.nil?
    
    co = Contact.find_by_id contact_id
    
    if co.nil? 
      self.errors.add(:contact_id, "Harus ada Contact Id")
      return self 
    end
  end
  
  def valid_employee_id
    return if  employee_id.nil?
    ep = Employee.find_by_id employee_id
    if ep.nil? 
      self.errors.add(:employee_id, "Harus ada Employee Id")
      return self 
    end
  end
  
  def valid_exchange_id
    return if  exchange_id.nil?
    ec = Exchange.find_by_id exchange_id
    if ec.nil? 
      self.errors.add(:exchange_id, "Harus ada Exchange Id")
      return self 
    end
  end    
  
  def self.create_object( params )
    new_object = self.new
    new_object.contact_id = params[:contact_id]
    new_object.employee_id = params[:employee_id]
    new_object.order_date = params[:order_date]
    new_object.order_type = params[:order_type]
    new_object.description = params[:description]
    new_object.nomor_surat = params[:nomor_surat]
    new_object.exchange_id = params[:exchange_id]
    new_object.save
    new_object.code = "VO-" + new_object.id.to_s  
    new_object.save
    
    return new_object
  end
  
  def update_object( params ) 
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.virtual_order_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.contact_id = params[:contact_id]
    self.employee_id = params[:employee_id]
    self.description = params[:description]
    self.order_date = params[:order_date]
    self.order_type = params[:order_type]
    self.nomor_surat = params[:nomor_surat]
    self.exchange_id = params[:exchange_id]
    self.save 
    return self
  end
    
  def confirm_object( params )  
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.virtual_order_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
   
    self.confirmed_at = params[:confirmed_at]
    self.is_confirmed = true  
    
    if self.save 
      self.update_virtual_order_confirm    
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
      self.update_virtual_order_unconfirm
    end
    return self
  end
   
  
  def delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    
    if self.virtual_order_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    
    self.destroy
    return self
  end
  
  def update_virtual_order_confirm
    self.virtual_order_details.each do |pod|
      new_stock_mutation = StockMutation.create_object(
        :source_class => self.class.to_s, 
        :source_id => self.id ,  
        :amount => pod.amount ,  
        :status => ADJUSTMENT_STATUS[:addition],  
        :mutation_date => self.order_date ,  
        :item_id => pod.item_id,
        :item_case => ITEM_CASE[:pending_delivery],
        :source_code => self.code
        ) 
      new_stock_mutation.stock_mutate_object
    end
  end
  
  def update_virtual_order_unconfirm
    self.virtual_order_details.each do |pod|
      stock_mutation = StockMutation.where(
        :source_class => self.class.to_s, 
        :source_id => self.id,
        :item_id => pod.item_id
        ).first
      stock_mutation.reverse_stock_mutate_object  
      stock_mutation.delete_object
    end
  end
  
  def update_is_delivery_completed
    if self.virtual_order_details.where{(pending_delivery_amount.gt 0)}.count == 0
      self.is_delivery_completed = true
    else
      self.is_delivery_completed = false
    end    
    self.save
  end
end
