class ClosingDetail < ActiveRecord::Base
  belongs_to :closing
  belongs_to :exchange
  validates_presence_of :closing_id
  validates_presence_of :exchange_id
  validates_presence_of :rate
  validate  :valid_closing_id
  validate  :valid_exchange_id
  
  def self.active_objects
    self
  end
  
  def valid_closing_id
    return if closing_id.nil?
    cls = Closing.find_by_id closing_id
    if cls.nil? 
      self.errors.add(:closing_id, "Harus ada Closing id")
      return self 
    end
  end
  
  def valid_exchange_id
    return if exchange_id.nil?
    exc = Exchange.find_by_id exchange_id
    if exc.nil? 
      self.errors.add(:exchange_id, "Harus ada Exchange Id")
      return self 
    end
  end
  
  def self.create_object(params)
    new_object = self.new
    closing = Closing.find_by_id(params[:closing_id])
    if not closing.nil?
      if closing.is_closed?
        new_object.errors.add(:generic_errors, "Sudah di closing")
        return new_object 
      end
    end
    new_object.closing_id = params[:closing_id]
    new_object.exchange_id = params[:exchange_id]
    new_object.rate = BigDecimal("1")
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.closing.is_closed?
      self.errors.add(:generic_errors, "Sudah di closing")
      return self 
    end
    self.rate = BigDecimal( params[:rate] || '0')
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.closing.is_closed?
      self.errors.add(:generic_errors, "Sudah di closing")
      return self 
    end
    self.destroy
    return self
  end
end
