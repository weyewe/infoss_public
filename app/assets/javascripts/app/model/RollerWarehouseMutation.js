Ext.define('AM.model.RollerWarehouseMutation', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
   	    	{ name: 'recovery_order_id', type: 'int' },
    	    { name: 'recovery_order_code', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'warehouse_from_id', type: 'int' },
    	    { name: 'warehouse_from_name', type: 'string' },
    	    { name: 'warehouse_to_id', type: 'int' },
    	    { name: 'warehouse_to_name', type: 'string' },
    	    { name: 'mutation_date', type: 'string' },
    	    { name: 'is_confirmed', type: 'boolean' },
   			{ name: 'confirmed_at', type: 'string' },
  			{ name: 'amount', type: 'int' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/roller_warehouse_mutations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_warehouse_mutations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_warehouse_mutation : record.data };
				}
			}
		}
	
  
});
