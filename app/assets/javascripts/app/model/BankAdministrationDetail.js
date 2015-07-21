Ext.define('AM.model.BankAdministrationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
	        { name: 'bank_administration_id', type: 'int' }, 
    	    { name: 'id', type: 'int' },
    	    { name: 'account_id', type: 'int' },
    	    { name: 'account_name', type: 'string' },
    	    { name: 'account_code', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'description', type: 'string' },
    	    { name: 'status', type: 'int' },
    	    { name: 'status_text', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'is_legacy', type: 'boolean' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/bank_administration_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'bank_administration_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { bank_administration_detail : record.data };
				}
			}
		}
	
  
});
