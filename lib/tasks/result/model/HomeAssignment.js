Ext.define('AM.model.HomeAssignment', {
  	extend: 'Ext.data.Model',
  	fields: [

	 
    	{ name: 'id', type: 'int' },
    	{ name: 'transaction_datetime', type: 'string' },
			{ name: 'description', type: 'string' } ,
			{ name: 'is_confirmed', type: 'boolean' } ,  // on start group loan
			{ name: 'confirmed_at', type: 'string' }   ,
			{ name: 'code', type: 'string' }   ,
			{ name: 'is_deleted', type: 'boolean' }   ,
			{ name: 'deleted_at', type: 'string' }  
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/home_assignments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'home_assignments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { home_assignment : record.data };
				}
			}
		}
	
  
});
