Ext.define('AM.model.PaymentRequestDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
	        { name: 'payment_request_id', type: 'int' }, 
	        { name: 'id', type: 'int' }, 
	        { name: 'status', type: 'int' }, 
	        { name: 'status_text', type: 'string' }, 
	        { name: 'amount', type: 'string' }, 
	        { name: 'code', type: 'string' }, 
	        { name: 'account_id', type: 'int' }, 
	        { name: 'account_name', type: 'string' }, 
	        { name: 'account_code', type: 'string' }, 
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payment_request_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_request_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_request_detail : record.data };
				}
			}
		}
	
  
});
