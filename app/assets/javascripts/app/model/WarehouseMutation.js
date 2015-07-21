Ext.define('AM.model.WarehouseMutation', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'mutation_date', type: 'string' },
			{ name: 'code', type: 'string' } ,
			
			{ name: 'warehouse_from_id', type: 'int' },
    	    { name: 'warehouse_from_name', type: 'string' },
    	    
    	    { name: 'warehouse_to_id', type: 'int' },
    	    { name: 'warehouse_to_name', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/warehouse_mutations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'warehouse_mutations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { warehouse_mutation : record.data };
				}
			}
		}
	
  
});
