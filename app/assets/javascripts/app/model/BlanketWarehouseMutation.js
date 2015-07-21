Ext.define('AM.model.BlanketWarehouseMutation', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'blanket_order_id', type: 'int' },
    	    { name: 'blanket_order_production_no', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'warehouse_from_id', type: 'int' },
    	    { name: 'warehouse_from_name', type: 'string' },
    	    { name: 'warehouse_to_id', type: 'int' },
    	    { name: 'warehouse_to_name', type: 'string' },
    	    { name: 'mutation_date', type: 'string' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'confirmed_at', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blanket_warehouse_mutations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blanket_warehouse_mutations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blanket_warehouse_mutation : record.data };
				}
			}
		}
	
  
});
