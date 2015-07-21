Ext.define('AM.model.ReceiptVoucherDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	{ name: 'id', type: 'int' },
    	{ name: 'transaction_datetime', type: 'string' },
			{ name: 'receipt_voucher_id', type: 'int' } ,
			{ name: 'account_id', type: 'int' } ,  // on start group loan
			{ name: 'account_name', type: 'string' }   ,
			{ name: 'entry_case', type: 'int' }   ,
			{ name: 'entry_case_text', type: 'string' }  ,
			{ name: 'amount', type: 'string' },  
			{ name: 'description', type: 'string' }  
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/receipt_voucher_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'receipt_voucher_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { receipt_voucher_detail : record.data };
				}
			}
		}
	
  
});
