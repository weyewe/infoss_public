Ext.define('AM.model.TemporaryDeliveryOrderDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
	        { name: 'temporary_delivery_order_id', type: 'int' }, 
    	    { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'sales_order_detail_id', type: 'int' },
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_name', type: 'string' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'is_reconciled', type: 'boolean' },
    	    { name: 'is_all_completed', type: 'boolean' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'waste_cogs', type: 'string' },
    	    { name: 'waste_amount', type: 'string' },
    	    { name: 'restock_amount', type: 'string' },
    	    { name: 'selling_price', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/temporary_delivery_order_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'temporary_delivery_order_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { temporary_delivery_order_detail : record.data };
				}
			}
		}
	
  
});
