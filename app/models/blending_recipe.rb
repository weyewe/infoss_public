class BlendingRecipe < ActiveRecord::Base
  
  has_many :blending_recipe_details
  validates_presence_of :name
  validates_presence_of :target_item_id
  validate :valid_target_item
  
  def valid_target_item
    return if target_item_id.nil? 
    target_item = Item.find_by_id(target_item_id)
    if target_item.nil? 
      self.errors.add(:target_item_id, "Harus ada target_item_id")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def active_children
    self.blending_recipe_details
  end
  
  def target_item
    Item.find_by_id(self.target_item_id)
  end
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.target_item_id = params[:target_item_id]
    new_object.target_amount = params[:target_amount]
    if new_object.save
    end
    return new_object
  end
  
  def update_object(params)
    if self.blending_recipe_details.count > 0 
      self.errors.add(:generic_errors,"Sudah memiliki detail")
      return self
    end
    if BlendingWorkOrder.where(:blending_recipe_id => self.id).count > 0
      self.errors.add(:generic_errors,"Sudah digunakan di BlendingWorkOrder")
      return self
    end
    self.name = params[:name]
    self.description = params[:description]
    self.target_item_id = params[:target_item_id]
    self.target_amount = params[:target_amount]
    if self.save
    end
    return self
  end
  
  def delete_object
    if self.blending_recipe_details.count > 0 
      self.errors.add(:generic_errors,"Sudah memiliki detail")
      return self
    end
    if BlendingWorkOrder.where(:blending_recipe_id => self.id).count > 0
      self.errors.add(:generic_errors,"Sudah digunakan di BlendingWorkOrder")
      return self
    end
    self.destroy
    return self
  end
  
  
end
