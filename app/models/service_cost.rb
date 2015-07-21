class ServiceCost < ActiveRecord::Base
  belongs_to :item
  belongs_to :roller_builder
  
  def self.active_objects
    self
  end
    
  def self.create_object(params)
    new_object = self.new 
    new_object.item_id = params[:item_id]
    new_object.item_id = params[:roller_builder_id]
    new_object.save 
    return self 
  end
   
  def self.find_or_create_object(params)
    service_cost = ServiceCost.where(:roller_builder_id =>params[:roller_builder_id]).first
    if service_cost.nil?
      service_cost = self.new 
      service_cost.roller_builder_id = params[:roller_builder_id]
      if service_cost.save 
        service_cost.item_id = service_cost.roller_builder.roller_used_core_item.item.id
        service_cost.save
      end
    end
    return service_cost
  end
  
  def update_amount(amount)
    self.amount += amount
    self.save
  end  
  
  def calculate_avg_price(params)
    new_amount = self.amount + params[:added_amount]
    original_avg_price = self.avg_price
    avg_price = 0 
 
    if ( new_amount ) > 0  
      a = self.amount * original_avg_price
      b = params[:added_amount] * params[:added_avg_price]
      c = new_amount
      avg_price = (
          (a+b)/c
        )
    end
    self.amount = new_amount
    self.avg_price = avg_price
    self.save  
    return self
  end
  
end
