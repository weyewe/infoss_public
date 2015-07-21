class PurchaseInvoiceMigration < ActiveRecord::Base
  belongs_to :exchange
  belongs_to :contact
  
  
  def self.active_objects
    self
  end
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.nomor_surat = params[:nomor_surat]
    new_object.contact_id = params[:contact_id]
    new_object.exchange_id = params[:exchange_id]
    new_object.amount_payable = BigDecimal( params[:amount_payable] || '0')
    new_object.exchange_rate_amount = BigDecimal( params[:exchange_rate_amount] || '0')
    new_object.tax = params[:tax]
    new_object.dpp = params[:dpp]
    new_object.invoice_date = params[:invoice_date]
    if new_object.save
      new_object.generate_payable
      AccountingService::CreatePurchaseInvoiceMigrationJournal.create_confirmation_journal(new_object)
    end
    return new_object
  end

  def generate_payable
    Payable.create_object(
      :source_class => self.class.to_s, 
      :source_id => self.id ,  
      :contact_id => self.contact_id,
      :amount => self.amount_payable ,  
      :due_date => self.invoice_date ,  
      :exchange_id => self.exchange_id,
      :exchange_rate_amount => self.exchange_rate_amount,
      :source_code => self.nomor_surat
    ) 
  end
    
end
