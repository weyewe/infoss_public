
Ext.define('AM.model.Exchange', {
  	extend: 'Ext.data.Model',
  	 
      
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
		{ name: 'description', type: 'string' },
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/exchanges',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'exchanges',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { exchange : record.data };
				}
			}
		}
	
  
});