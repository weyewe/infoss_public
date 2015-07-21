Ext.define('AM.model.WarehouseMutationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'warehouse_mutation_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
			{ name: 'code', type: 'string' } ,
			
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/warehouse_mutation_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'warehouse_mutation_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { warehouse_mutation_detail : record.data };
				}
			}
		}
	
  
});
