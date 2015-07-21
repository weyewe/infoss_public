Ext.define('AM.model.TemporaryDeliveryOrderDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	{ name: 'id', type: 'int' },
    	{ name: 'transaction_datetime', type: 'string' },
			{ name: 'temporary_delivery_order_id', type: 'int' } ,
			{ name: 'account_id', type: 'int' } ,  // on start group loan
			{ name: 'account_name', type: 'string' }   ,
			{ name: 'entry_case', type: 'int' }   ,
			{ name: 'entry_case_text', type: 'string' }  ,
			{ name: 'amount', type: 'string' },  
			{ name: 'description', type: 'string' }  
			
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
