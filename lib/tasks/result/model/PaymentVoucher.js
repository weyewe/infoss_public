Ext.define('AM.model.PaymentVoucher', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'branch_id', type: 'int' },
    	{ name: 'branch_code', type: 'string' },
    	{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' } , 
			{ name: 'code', type: 'string' }     ,
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payment_vouchers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_vouchers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_voucher : record.data };
				}
			}
		}
	
  
});
