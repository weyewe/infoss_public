Ext.define('AM.model.TemporaryDeliveryOrder', {
  	extend: 'Ext.data.Model',
  	fields: [

	 
    	{ name: 'id', type: 'int' },
    	{ name: 'transaction_datetime', type: 'string' },
			{ name: 'description', type: 'string' } ,
			{ name: 'is_confirmed', type: 'boolean' } ,  // on start group loan
			{ name: 'confirmed_at', type: 'string' }   ,
			{ name: 'code', type: 'string' }   ,
			{ name: 'is_deleted', type: 'boolean' }   ,
			{ name: 'deleted_at', type: 'string' }  
			
			
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
