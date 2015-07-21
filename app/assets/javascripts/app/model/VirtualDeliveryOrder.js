Ext.define('AM.model.VirtualDeliveryOrder', {
  	extend: 'Ext.data.Model',
  	fields: [
    	    { name: 'id', type: 'int' },
    	    { name: 'delivery_date', type: 'string' },
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
    	    
    	    { name: 'virtual_order_id', type: 'int' },
    	    { name: 'virtual_order_code', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/virtual_delivery_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'virtual_delivery_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { virtual_delivery_order : record.data };
				}
			}
		}
	
  
});
