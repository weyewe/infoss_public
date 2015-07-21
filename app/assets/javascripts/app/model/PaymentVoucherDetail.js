Ext.define('AM.model.PaymentVoucherDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
		    { name: 'id', type: 'int' },
	      { name: 'payment_voucher_id', type: 'int' }, 
	      { name: 'code', type: 'string' }, 
	      { name: 'amount', type: 'string' }, 
	      { name: 'amount_paid', type: 'string' }, 
	      { name: 'pph_21', type: 'string' }, 
	      { name: 'pph_23', type: 'string' }, 
	      { name: 'payable_id', type: 'int' }, 
	      { name: 'payable_source_class', type: 'string' }, 
	      { name: 'payable_source_code', type: 'string' }, 
	      { name: 'payable_amount', type: 'string' }, 
	      { name: 'payable_remaining_amount', type: 'string' }, 
	      { name: 'payable_exchange_name', type: 'string' }, 
	      { name: 'payable_exchange_rate_amount', type: 'string' }, 
	      { name: 'payable_due_date', type: 'string' }, 
	      { name: 'payable_pending_clearence_amount', type: 'string' }, 
	      { name: 'rate', type: 'string' }, 
	      { name: 'description', type: 'string' }, 
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payment_voucher_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payment_voucher_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payment_voucher_detail : record.data };
				}
			}
		}
	
  
});
