Ext.define('AM.model.DeliveryOrder', {
  	extend: 'Ext.data.Model',
  	fields: [
    	    { name: 'id', type: 'int' },
    	    { name: 'delivery_date', type: 'string' },
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
    	    
    	    { name: 'sales_order_id', type: 'int' },
    	    { name: 'sales_order_code', type: 'string' },
    	    { name: 'sales_order_nomor_surat', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/delivery_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'delivery_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { delivery_order : record.data };
				}
			}
		}
	
  
});
