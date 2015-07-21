Ext.define('AM.model.Home', {
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
			url: 'api/homes',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'homes',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { home : record.data };
				}
			}
		}
	
  
});
