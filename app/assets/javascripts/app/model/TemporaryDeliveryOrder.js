Ext.define('AM.model.TemporaryDeliveryOrder', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'order_type', type: 'int' },
    	    { name: 'delivery_order_id', type: 'int' },
    	    { name: 'delivery_order_code', type: 'string' },
    	    { name: 'delivery_order_nomor_surat', type: 'string' },
    	    { name: 'delivery_date', type: 'string' },
    	    { name: 'contact_name', type: 'string' },
    	    { name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
    	    { name: 'nomor_surat', type: 'string' },
    	    { name: 'total_waste_cogs', type: 'string' },
    	    { name: 'is_delivery_completed', type: 'boolean' },
    	    { name: 'is_reconciled', type: 'boolean' },
    	    { name: 'is_pushed', type: 'boolean' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'push_date', type: 'string' },
    	    { name: 'confirmed_at', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/temporary_delivery_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'temporary_delivery_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { temporary_delivery_order : record.data };
				}
			}
		}
	
  
});
