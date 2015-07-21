
json.success true 
json.total @total
 

json.records @objects do |object|
    
     json.temporary_delivery_order_id object.temporary_delivery_order_id 
    
	json.id 								object.id  
	json.code 								object.code  
	json.sales_order_detail_id 								object.sales_order_detail_id  
	json.item_id 								object.item_id  
	json.item_name 								object.item.name  
	json.item_sku 								object.item.sku  
	json.is_reconciled 								object.is_reconciled  
	json.is_all_completed 								object.is_all_completed  
	json.amount 								object.amount  
	json.waste_cogs 								object.waste_cogs  
	json.waste_amount 								object.waste_amount  
	json.restock_amount 								object.restock_amount  
	json.selling_price 								object.selling_price  
 
	
	
end
