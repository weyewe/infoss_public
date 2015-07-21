Ext.define('AM.model.PurchaseOrderDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'purchase_order_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'pending_receival_amount', type: 'string' },
			{ name: 'price', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_order_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_order_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_order_detail : record.data };
				}
			}
		}
	
  
});
