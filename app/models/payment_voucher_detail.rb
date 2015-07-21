class PaymentVoucherDetail < ActiveRecord::Base

  validate :valid_payable_and_amount
  validate :valid_payment_voucher
  belongs_to :payable
  belongs_to :payment_voucher
  
  
  def self.active_objects
    self
  end
  
  def valid_payment_voucher
    return if  payment_voucher_id.nil?
    cb = PaymentVoucher.find_by_id payment_voucher_id
    if cb.nil? 
      self.errors.add(:payment_voucher_id, "Harus ada payment_voucher id")
      return self 
    end
  end 
   
  def valid_payable_and_amount
    return if  payable_id.nil?
    pyb = Payable.find_by_id payable_id
    
    if pyb.nil? 
      self.errors.add(:payable_id, "Harus ada payable id")
      return self 
    end
    
    if pyb.remaining_amount < amount
      self.errors.add(:payable_id, "Amount melebih amount payable")
      return self 
    end
    
    pvcount = PaymentVoucherDetail.where(
      :payment_voucher_id => payment_voucher_id,
      :payable_id => pyb.id
      ).count  
    
    if self.persisted?
       if pvcount > 1
         self.errors.add(:payable_id, "Payable sudah terpakai")
      return self 
       end
    else
       if pvcount > 0
         self.errors.add(:payable_id, "Payable sudah terpakai")
      return self 
       end
    end
  end 
  
  def calculateTotalAmount
    amount = 0
    pph_21 = 0
    pph_23 = 0
    PaymentVoucherDetail.where(:payment_voucher_id =>payment_voucher_id).each do |pvd|
      amount += pvd.amount
      pph_23 += pvd.pph_23
    end
    payment_voucher = PaymentVoucher.find_by_id(payment_voucher_id)
    payment_voucher.update_amount(amount)
    payment_voucher.update_total_pph_21(pph_21)
    payment_voucher.update_total_pph_23(pph_23)
  end
  
  def self.create_object(params)
    new_object = self.new
    payment_voucher = PaymentVoucher.find_by_id(params[:payment_voucher_id])
    if not payment_voucher.nil?
      if payment_voucher.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.payment_voucher_id = params[:payment_voucher_id]
    new_object.payable_id = params[:payable_id]
    new_object.amount_paid = params[:amount_paid]
 
    new_object.amount = (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
 
    new_object.pph_21 = params[:pph_21]
    new_object.pph_23 = params[:pph_23]
    new_object.rate = BigDecimal( params[:rate] || '0')
    if new_object.save
      new_object.calculateTotalAmount
    end
    return new_object
  end
  
  def update_object(params)
    if self.payment_voucher.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.payable_id = params[:payable_id]
    self.amount_paid = params[:amount_paid]
 
    self.amount = (BigDecimal( params[:amount_paid]) / BigDecimal( params[:rate]))
 
    self.pph_21 = params[:pph_21]
    self.pph_23 = params[:pph_23]
    self.rate = BigDecimal( params[:rate] || '0')
    if self.save
      self.calculateTotalAmount
    end
    return self
  end
  
  def delete_object
    if self.payment_voucher.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
    return self
  end
  
end
