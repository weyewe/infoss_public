Ext.define('AM.model.ReceiptVoucherDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
      { name: 'id', type: 'int' },
      { name: 'receipt_voucher_id', type: 'int' }, 
      { name: 'code', type: 'string' }, 
      { name: 'amount', type: 'string' }, 
      { name: 'amount_paid', type: 'string' }, 
      { name: 'pph_21', type: 'string' }, 
      { name: 'pph_23', type: 'string' }, 
      { name: 'receivable_id', type: 'int' }, 
      { name: 'receivable_source_class', type: 'string' }, 
      { name: 'receivable_source_code', type: 'string' }, 
      { name: 'receivable_amount', type: 'string' }, 
      { name: 'receivable_remaining_amount', type: 'string' }, 
      { name: 'receivable_exchange_name', type: 'string' }, 
      { name: 'receivable_exchange_rate_amount', type: 'string' }, 
      { name: 'receivable_due_date', type: 'string' }, 
      { name: 'receivable_pending_clearence_amount', type: 'string' }, 
      { name: 'rate', type: 'string' }, 
      { name: 'description', type: 'string' }, 
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
