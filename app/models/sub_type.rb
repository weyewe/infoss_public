class SubType < ActiveRecord::Base
  belongs_to :item_type 
  
  validates_uniqueness_of :name
  validates_presence_of :name 
  validate :valid_item_type
  
  def valid_item_type
    return if item_type_id.nil? 
    item_type = ItemType.find_by_id(item_type_id)
    if item_type.nil? 
      self.errors.add(:item_type_id, "Harus ada item_type_id")
      return self
    end
  end
  
  def self.active_objects
    self
  end
  
  def self.create_object(params)
    new_object = self.new
    new_object.name = params[:name]
    new_object.item_type_id = params[:item_type_id]
    new_object.save
    return new_object
  end
  
  def update_object(params)
    self.name = params[:name]
    self.item_type_id = params[:item_type_id]
    self.save
    return self
  end
  
  def delete_object
    if Item.where(:sub_type_id => self.id).count > 0
      self.errors.add(:generic_errors, "SubType sudah terpakai")
      return self
    end
    self.destroy
    return self
  end
  
end
