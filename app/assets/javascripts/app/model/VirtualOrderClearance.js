Ext.define('AM.model.VirtualOrderClearance', {
  	extend: 'Ext.data.Model',
  	fields: [
    	    { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'virtual_delivery_order_id', type: 'int' },
    	    { name: 'virtual_delivery_order_code', type: 'string' },
    	    { name: 'clearance_date', type: 'string' },
    	    { name: 'total_waste_cogs', type: 'string' },
    	    { name: 'is_waste', type: 'string' },
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/virtual_order_clearances',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'virtual_order_clearances',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { virtual_order_clearance : record.data };
				}
			}
		}
	
  
});
