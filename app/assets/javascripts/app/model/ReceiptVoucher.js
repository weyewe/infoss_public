Ext.define('AM.model.ReceiptVoucher', {
  	extend: 'Ext.data.Model',
  	fields: [

    	   { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    { name: 'cash_bank_id', type: 'int' },
    	    { name: 'cash_bank_name', type: 'string' },
    	    { name: 'cash_bank_exchange_name', type: 'string' },
    	    { name: 'status_pembulatan', type: 'int' },
    	    { name: 'receipt_date', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'rate_to_idr', type: 'string' },
    	    { name: 'total_pph_23', type: 'string' },
    	    { name: 'biaya_bank', type: 'string' },
    	    { name: 'pembulatan', type: 'string' },
    	    { name: 'no_bukti', type: 'string' },
    	    { name: 'gbch_no', type: 'string' },
    	    { name: 'is_gbch', type: 'boolean' },
    	    { name: 'is_reconciled', type: 'boolean' },
    	    { name: 'reconciliation_date', type: 'string' },
    	    { name: 'due_date', type: 'string' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'confirmed_at', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/receipt_vouchers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'receipt_vouchers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { receipt_voucher : record.data };
				}
			}
		}
	
  
});
