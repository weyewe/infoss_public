class BlanketOrderDetailUsage < ActiveRecord::Base
  belongs_to :blanket_order_detail
  
  def self.create_object( params  )
    new_object  = self.new                            
    new_object.blanket_order_detail_id            = params[:blanket_order_detail_id         ]
    new_object.roll_blanket_batch_instance_id     = params[:roll_blanket_batch_instance_id  ]
    new_object.used_amount                        = params[:used_amount                     ]
    new_object.defect_amount                      = params[:defect_amount                   ]
    new_object.cut_amount                         = params[:cut_amount                      ]
    new_object.reject_amount                      = params[:reject_amount                   ] 
    new_object.save 
    
    return new_object 
  end 

  def update_object( params ) 
    self.roll_blanket_batch_instance_id     = params[:roll_blanket_batch_instance_id  ]
    self.used_amount                        = params[:used_amount                     ]
    self.defect_amount                      = params[:defect_amount                   ]
    self.cut_amount                         = params[:cut_amount                      ]
    self.reject_amount                      = params[:reject_amount                   ] 
    self.save 
    
    return self 
  end  
  
  def delete_object
    if self.blanket_order_detail.blanket_order.is_finished?
      self.errors.add(:generic_errors, "Sudah konfirmasi FINISH blanket order detail")
      return self 
    end
    
    if self.blanket_order_detail.blanket_order.is_rejected?
      self.errors.add(:generic_errors, "Sudah konfirmasi REJECT blanket order detail")
      return self 
    end
    
    
    self.destroy 
  end      
  
  def confirm_object 
  end  
  
  def unconfirm_object  
  end


end
