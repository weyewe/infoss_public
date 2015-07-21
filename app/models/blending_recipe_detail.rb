class BlendingRecipeDetail < ActiveRecord::Base
    
  belongs_to :blending_recipe
  belongs_to :item
  validates_presence_of :blending_recipe_id
  validates_presence_of :item_id
  validate :valid_blending_item_id
  
  def self.active_objects
    self
  end
  
  def valid_blending_recipe
    return if  blending_recipe_id.nil?
    br = BlendingRecipe.find_by_id blending_recipe_id
    if br.nil? 
      self.errors.add(:blending_recipe_id, "Harus ada Blending Recipe Id")
      return self 
    end
  end 
  
  def valid_blending_item_id
    return if item_id.nil?
    item = Item.find_by_id item_id
    if item.nil? 
      self.errors.add(:item_id, "Harus ada Item Id")
      return self 
    end
  end
  
  def self.create_object(params)
    new_object = self.new
    if BlendingWorkOrder.where(:blending_recipe_id => params[:blending_recipe_id]).count > 0
      new_object.errors.add(:generic_errors,"Sudah digunakan di BlendingWorkOrder")
      return new_object
    end
    new_object.blending_recipe_id = params[:blending_recipe_id]
    new_object.item_id = params[:item_id]
    new_object.amount = BigDecimal( params[:amount] || '0')
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if BlendingWorkOrder.where(:blending_recipe_id => self.blending_recipe_id).count > 0
      self.errors.add(:generic_errors,"Sudah digunakan di BlendingWorkOrder")
      return self
    end
    self.item_id = params[:item_id]
    self.amount = BigDecimal( params[:amount] || '0')
    if self.save
    end
    return self
  end
  
  def delete_object
    if BlendingWorkOrder.where(:blending_recipe_id => self.blending_recipe_id).count > 0
      self.errors.add(:generic_errors,"Sudah digunakan di BlendingWorkOrder")
      return self
    end
    self.destroy
    return self
  end  
  
end
