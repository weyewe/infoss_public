Ext.define('AM.model.BlanketWarehouseMutationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'id', type: 'int' },
    	    { name: 'blanket_warehouse_mutation_id', type: 'int' },
    	    { name: 'blanket_order_detail_id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    { name: 'quantity', type: 'int' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blanket_warehouse_mutation_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blanket_warehouse_mutation_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blanket_warehouse_mutation_detail : record.data };
				}
			}
		}
	
  
});
