Ext.define('AM.model.VirtualOrderDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	{ name: 'id', type: 'int' },
    	{ name: 'transaction_datetime', type: 'string' },
			{ name: 'virtual_order_id', type: 'int' } ,
			{ name: 'account_id', type: 'int' } ,  // on start group loan
			{ name: 'account_name', type: 'string' }   ,
			{ name: 'entry_case', type: 'int' }   ,
			{ name: 'entry_case_text', type: 'string' }  ,
			{ name: 'amount', type: 'string' },  
			{ name: 'description', type: 'string' }  
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/virtual_order_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'virtual_order_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { virtual_order_detail : record.data };
				}
			}
		}
	
  
});
