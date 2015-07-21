Ext.define('AM.model.PurchaseReceivalDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
 
	
	
	        { name: 'purchase_receival_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
			{ name: 'code', type: 'string' } ,
			
			{ name: 'purchase_order_detail_id', type: 'int' }, 
			{ name: 'purchase_order_detail_code', type: 'string' } ,
			{ name: 'purchase_order_detail_pending_receival_amount', type: 'string' } ,
			
			{ name: 'purchase_order_detail_item_id', type: 'int' },
    	    { name: 'purchase_order_detail_item_sku', type: 'string' },
    	    { name: 'purchase_order_detail_item_name', type: 'string' },
    	    
    	    { name: 'purchase_order_detail_item_uom_id', type: 'int' },
    	    { name: 'purchase_order_detail_item_uom_name', type: 'string' }, 
			
	 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_receival_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_receival_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_receival_detail : record.data };
				}
			}
		}
	
  
});
