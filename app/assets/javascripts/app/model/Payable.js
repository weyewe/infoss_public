Ext.define('AM.model.Payable', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'source_class', type: 'string' },
    	{ name: 'source_id', type: 'int' },
    	{ name: 'source_code', type: 'string' },
    	{ name: 'amount', type: 'string' },
    	{ name: 'remaining_amount', type: 'string' },
    	{ name: 'exchange_id', type: 'int' },
    	{ name: 'exchange_name', type: 'string' },
    	{ name: 'contact_id', type: 'int' },
    	{ name: 'contact_name', type: 'string' },
    	{ name: 'exchange_rate_amount', type: 'string' },
    	{ name: 'due_date', type: 'string' },
    	{ name: 'pending_clearence_amount', type: 'string' },
    	{ name: 'is_completed', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/payables',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'payables',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { payable : record.data };
				}
			}
		}
	
  
});
