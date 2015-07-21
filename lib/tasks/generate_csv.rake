require 'rubygems'
require 'pg'
require 'active_record'
require 'csv'


namespace :csv_zga do 
    
  task :item_csv do 
    
    lookup_location = Rails.root.to_s + "/" + "item_inspect.csv"
  
    CSV.open(lookup_location, 'w') do |csv|
      
      title_array = [
          "SKU",
          "ItemTypeName",
          "Name",
          "Uom",
          "Qty",
          "Price",
          "Currency"
        ]
      csv << title_array
      
      Item.joins(:item_type, :uom, :exchange).order("id ASC").find_each do |item|
        array = []
        
        array << item.sku
        array << item.item_type.name 
        array << item.name 
        array << item.uom.name 
        array << item.amount.to_s 
        
        current_item_id = item.id 
        
        first_confirmed_stock_adjustment_detail = StockAdjustmentDetail.joins(:stock_adjustment).where{
            ( stock_adjustment.is_confirmed.eq true ) & 
            ( item_id.eq current_item_id)
        }.order("id ASC").first 
        
        price = BigDecimal("0")
        if not first_confirmed_stock_adjustment_detail.nil?
          price = first_confirmed_stock_adjustment_detail.price
        end
        
        array << price.to_s
        array << item.exchange.name 
        
        
        csv << array 
      end
      
 
    end
  end
    
end