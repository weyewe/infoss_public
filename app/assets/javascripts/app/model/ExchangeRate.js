
Ext.define('AM.model.ExchangeRate', {
  	extend: 'Ext.data.Model',
  	 
      
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'ex_rate_date', type: 'string' },
		{ name: 'exchange_name', type: 'string' },
		{ name: 'exchange_id', type: 'int' },
		{ name: 'rate', type: 'string' },
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/exchange_rates',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'exchange_rates',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { exchange_rate : record.data };
				}
			}
		}
	
  
});