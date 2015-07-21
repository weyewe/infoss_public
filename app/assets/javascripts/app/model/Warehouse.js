
Ext.define('AM.model.Warehouse', {
  	extend: 'Ext.data.Model',
  	 
      
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
		{ name: 'code', type: 'string' },
		{ name: 'description', type: 'string' },
 
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/warehouses',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'warehouses',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { warehouse : record.data };
				}
			}
		}
	
  
});
