Ext.define('AM.model.Template', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'branch_id', type: 'int' },
    	{ name: 'branch_code', type: 'string' },
    	{ name: 'name', type: 'string' },
			{ name: 'description', type: 'string' } , 
			{ name: 'code', type: 'string' }     ,
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/templates',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'templates',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { template : record.data };
				}
			}
		}
	
  
});
