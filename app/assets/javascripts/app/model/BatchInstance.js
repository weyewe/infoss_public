Ext.define('AM.model.BatchInstance', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'name', type: 'string' },
    	{ name: 'description', type: 'string' },
    	{ name: 'amount', type: 'string' },
    	{ name: 'total_allocated_amount', type: 'string' },
		{ name: 'manufactured_at', type: 'string' } , 
		{ name: 'item_id', type: 'int' }     ,
		{ name: 'item_sku', type: 'string' }     ,
		{ name: 'item_name', type: 'string' }     ,
		{ name: 'item_type_id', type: 'int' }     ,
		{ name: 'item_type_name', type: 'string' }     ,
 
	
	
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/batch_instances',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'batch_instances',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { batch_instance : record.data };
				}
			}
		}
	
  
});
