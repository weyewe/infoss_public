Ext.define('AM.model.CoreBuilder', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'name', type: 'string' },
    	{ name: 'description', type: 'string' },
		{ name: 'base_sku', type: 'string' },
		{ name: 'sku_new_core', type: 'string' },
		{ name: 'sku_used_core', type: 'string' },
		{ name: 'used_core_item_id', type: 'int' },
		{ name: 'used_core_item_amount', type: 'int' },
		{ name: 'new_core_item_id', type: 'int' },
		{ name: 'new_core_item_amount', type: 'int' },
		{ name: 'uom_id', type: 'int' },
		{ name: 'uom_name', type: 'string' },
		{ name: 'machine_id', type: 'int' },
		{ name: 'machine_name', type: 'string' },
		{ name: 'core_builder_type_case', type: 'string' },
		{ name: 'cd', type: 'string' },
		{ name: 'tl', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/core_builders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'core_builders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { core_builder : record.data };
				}
			}
		}
	
  
});
