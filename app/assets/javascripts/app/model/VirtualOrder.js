Ext.define('AM.model.VirtualOrder', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    { name: 'exchange_id', type: 'int' },
    	    { name: 'exchange_name', type: 'string' },
    	    { name: 'employee_id', type: 'int' },
    	    { name: 'employee_name', type: 'string' },
    	    { name: 'description', type: 'string' },
    	    { name: 'order_type', type: 'int' },
    	    { name: 'order_type_text', type: 'string' },
    	    { name: 'order_date', type: 'string' },
    	    { name: 'nomor_surat', type: 'string' },
    	    { name: 'is_delivery_completed', type: 'boolean' },
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/virtual_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'virtual_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { virtual_order : record.data };
				}
			}
		}
	
  
});
