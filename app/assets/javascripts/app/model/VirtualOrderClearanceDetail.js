Ext.define('AM.model.VirtualOrderClearanceDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
	        { name: 'virtual_order_clearance_id', type: 'int' }, 
    	    { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'virtual_delivery_order_detail_id', type: 'int' },
    	    { name: 'virtual_delivery_order_detail_item_name', type: 'string' },
    	    { name: 'virtual_delivery_order_detail_item_sku', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'waste_cogs', type: 'string' },
    	    { name: 'selling_price', type: 'string' },
  	],


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/virtual_order_clearance_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'virtual_order_clearance_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { virtual_order_clearance_detail : record.data };
				}
			}
		}
	
  
});
