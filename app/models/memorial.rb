class Memorial < ActiveRecord::Base
  has_many :memorial_details
 
  def self.active_objects
    return self
  end
  
  def active_children
    return self.memorial_details
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.description = params[:description]
    new_object.no_bukti = params[:no_bukti]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save  
      new_object.code = "MEM-" + new_object.id.to_s  
      new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.memorial_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.description = params[:description]
    self.no_bukti = params[:no_bukti]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save 
    end
    return self
  end
  
  def delete_object
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    if self.memorial_details.count > 0
      self.errors.add(:generic_errors, "Sudah memiliki detail")
      return self 
    end
    self.destroy
    return self
  end
  
  def confirm_object(params)
    if self.is_confirmed? 
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self
    end
    
    if self.memorial_details.count == 0
      self.errors.add(:generic_errors, "Tidak memiliki detail")
      return self 
    end
    
    if params[:confirmed_at].nil?
      self.errors.add(:generic_errors, "Harus ada tanggal konfirmasi")
      return self 
    end    
    
    debit = 0
    credit = 0
    self.memorial_details.each do |md|
      if md.status == NORMAL_BALANCE[:debet]
        debit += md.amount
      else
        credit += md.amount
      end
    end
    if (debit != credit) || (debit != self.amount)
      self.errors.add(:generic_errors, "Jumlah debit, credit, dan amount harus sama: #{self.amount}")
      return self
    end
    
    self.is_confirmed = true
    self.confirmed_at = params[:confirmed_at]
    if self.save
      AccountingService::CreateMemorialJournal.create_confirmation_journal(self)
    end  
    return self
  end
  
  def unconfirm_object()
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "belum di konfirmasi")
      return self 
    end
    self.is_confirmed = false
    self.confirmed_at = nil
    if self.save
       AccountingService::CreateMemorialJournal.undo_create_confirmation_journal(self)
    end
    return self
  end
  
end
