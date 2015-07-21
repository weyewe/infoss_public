Ext.define('AM.model.Memorial', {
  	extend: 'Ext.data.Model',
  	fields: [
    	    { name: 'id', type: 'int' },
			{ name: 'code', type: 'string' } ,
			{ name: 'no_bukti', type: 'string' } ,
			{ name: 'amount', type: 'string' } ,
			{ name: 'description', type: 'string' } ,
			
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/memorials',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'memorials',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { memorial : record.data };
				}
			}
		}
	
  
});
