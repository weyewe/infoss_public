class ReceiptVoucherDetail < ActiveRecord::Base
  
  validate :valid_receivable_and_amount
  validate :valid_receipt_voucher
  belongs_to :receivable
  belongs_to :receipt_voucher
  
  
  def self.active_objects
    self
  end
  
  def valid_receipt_voucher
    return if  receipt_voucher_id.nil?
    cb = ReceiptVoucher.find_by_id receipt_voucher_id
    if cb.nil? 
      self.errors.add(:receipt_voucher_id, "Harus ada receipt_voucher id")
      return self 
    end
  end 
   
  def valid_receivable_and_amount
    return if  receivable_id.nil?
    pyb = Receivable.find_by_id receivable_id
    
    if pyb.nil? 
      self.errors.add(:receivable_id, "Harus ada receivable id")
      return self 
    end
    
    if pyb.remaining_amount < amount
      self.errors.add(:receivable_id, "Amount melebih amount receivable")
      return self 
    end
    
    pvcount = ReceiptVoucherDetail.where(
      :receipt_voucher_id => receipt_voucher_id,
      :receivable_id => pyb.id
      ).count  
    
    if self.persisted?
       if pvcount > 1
         self.errors.add(:receivable_id, "Receivable sudah terpakai")
      return self 
       end
    else
       if pvcount > 0
         self.errors.add(:receivable_id, "Receivable sudah terpakai")
      return self 
       end
    end
  end 
  
  
  
  def calculateTotalAmount
    amount = 0
    pph_21 = 0
    pph_23 = 0
    ReceiptVoucherDetail.where(:receipt_voucher_id =>receipt_voucher_id).each do |pvd|
      amount += pvd.amount
      pph_23 += pvd.pph_23
    end
    receipt_voucher = ReceiptVoucher.find_by_id(receipt_voucher_id)
    receipt_voucher.update_amount(amount)
    receipt_voucher.update_total_pph_23(pph_23)
  end
  
  def self.create_object(params)
    new_object = self.new
    receipt_voucher = ReceiptVoucher.find_by_id(params[:receipt_voucher_id])
    if not receipt_voucher.nil?
      if receipt_voucher.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.receipt_voucher_id = params[:receipt_voucher_id]
    new_object.receivable_id = params[:receivable_id]
    new_object.amount_paid = params[:amount_paid]
 
    new_object.amount =  (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
 
    new_object.pph_23 = params[:pph_23]
    new_object.rate = params[:rate]
    if new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    if self.receipt_voucher.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.receivable_id = params[:receivable_id]
    self.amount_paid = params[:amount_paid]
 
    self.amount = (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
 
    self.pph_23 = params[:pph_23]
    self.rate = params[:rate]
    if self.save
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.receipt_voucher.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
end
