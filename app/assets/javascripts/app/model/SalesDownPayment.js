Ext.define('AM.model.SalesDownPayment', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'contact_id', type: 'int' },
    	{ name: 'contact_name', type: 'string' },
    	{ name: 'receivable_id', type: 'int' },
    	{ name: 'receivable_source_code', type: 'string' },
    	{ name: 'payable_id', type: 'int' },
    	{ name: 'payable_source_code', type: 'string' },
    	{ name: 'code', type: 'string' },
    	{ name: 'down_payment_date', type: 'string' },
    	{ name: 'due_date', type: 'string' },
    	{ name: 'exchange_id', type: 'int' },
    	{ name: 'exchange_name', type: 'string' },
    	{ name: 'exchange_rate_id', type: 'int' },
    	{ name: 'exchange_rate_amount', type: 'string' },
    	{ name: 'total_amount', type: 'string' },
    	{ name: 'is_confirmed', type: 'boolean' },
    	{ name: 'confirmed_at', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_down_payments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_down_payments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_down_payment : record.data };
				}
			}
		}
	
  
});
