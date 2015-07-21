Ext.define('AM.model.RollerWarehouseMutationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'id', type: 'int' },
    	    { name: 'roller_warehouse_mutation_id', type: 'int' },
   	    	{ name: 'recovery_order_detail_id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/roller_warehouse_mutation_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_warehouse_mutation_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_warehouse_mutation_detail : record.data };
				}
			}
		}
	
  
});
