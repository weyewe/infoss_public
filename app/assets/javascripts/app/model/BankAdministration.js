Ext.define('AM.model.BankAdministration', {
  	extend: 'Ext.data.Model',
  	fields: [
    	    { name: 'id', type: 'int' },
    	    { name: 'cash_bank_id', type: 'int' },
    	    { name: 'cash_bank_name', type: 'string' },
    	    { name: 'administration_date', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'no_bukti', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'exchange_rate_amount', type: 'string' },
    	    { name: 'exchange_rate_id', type: 'string' },
    	    { name: 'description', type: 'string' },
    	    { name: 'is_confirmed', type: 'string' },
    	    { name: 'confirmed_at', type: 'string' },
  	],
  	idProperty: 'id' ,

		proxy: {
			url: 'api/bank_administrations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'bank_administrations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { bank_administration : record.data };
				}
			}
		}
	
  
});
