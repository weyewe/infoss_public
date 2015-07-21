class VirtualOrderClearanceDetail < ActiveRecord::Base
    
  belongs_to :virtual_order_clearance
  belongs_to :virtual_delivery_order_detail
  
  def self.active_objects
    self
  end

  def self.create_object(params)
    new_object = self.new
    virtual_order_clearance = VirtualOrderClearance.find_by_id(params[:virtual_order_clearance_id])
    if not virtual_order_clearance.nil?
      if virtual_order_clearance.is_confirmed?
        new_object.errors.add(:generic_errors, "Sudah di konfirmasi")
        return new_object 
      end
    end
    new_object.virtual_delivery_order_detail_id = params[:virtual_delivery_order_detail_id]
    new_object.virtual_order_clearance_id = params[:virtual_order_clearance_id]
    new_object.amount = params[:amount]
    if new_object.save  
    new_object.code = "VOCD-" + new_object.id.to_s  
    new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.virtual_order_clearance.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.virtual_delivery_order_detail_id = params[:virtual_delivery_order_detail_id]
    self.virtual_order_clearance_id = params[:virtual_order_clearance_id]
    self.amount = params[:amount]
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.virtual_order_clearance.is_confirmed?
      self.errors.add(:generic_errors, "Sudah di konfirmasi")
      return self 
    end
    self.destroy
  end
end
