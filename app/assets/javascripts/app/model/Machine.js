Ext.define('AM.model.Machine', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'name', type: 'string' },
		{ name: 'code', type: 'string' },
		{ name: 'description', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/machines',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'machines',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { machine : record.data };
				}
			}
		}
	
  
});
