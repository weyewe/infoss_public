Ext.define('AM.model.DeliveryOrderDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
	
	        { name: 'delivery_order_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
			{ name: 'code', type: 'string' } ,
			
			{ name: 'sales_order_detail_id', type: 'int' }, 
			{ name: 'sales_order_detail_code', type: 'string' } ,
			{ name: 'sales_order_detail_pending_delivery_amount', type: 'string' } ,
			
			{ name: 'sales_order_detail_item_id', type: 'int' },
    	    { name: 'sales_order_detail_item_sku', type: 'string' },
    	    { name: 'sales_order_detail_item_name', type: 'string' },
    	    
    	    { name: 'sales_order_detail_item_uom_id', type: 'int' },
    	    { name: 'sales_order_detail_item_uom_name', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/delivery_order_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'delivery_order_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { delivery_order_detail : record.data };
				}
			}
		}
	
  
});
