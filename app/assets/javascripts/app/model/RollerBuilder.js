Ext.define('AM.model.RollerBuilder', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'base_sku', type: 'string' },
    	{ name: 'description', type: 'string' },
    	{ name: 'name', type: 'string' },
		{ name: 'rd', type: 'string' }     ,
		{ name: 'cd', type: 'string' }     ,
		{ name: 'rl', type: 'string' }     ,
		{ name: 'wl', type: 'string' }     ,
		{ name: 'tl', type: 'string' }     ,
		{ name: 'sku_roller_used_core', type: 'string' }     ,
		{ name: 'roller_used_core_item_id', type: 'int' }     ,
		{ name: 'sku_roller_new_core', type: 'string' }     ,
		{ name: 'roller_new_core_item_id', type: 'int' }     ,
		{ name: 'roller_used_core_item_amount', type: 'string' }     ,
		{ name: 'roller_new_core_item_amount', type: 'string' }     ,
		{ name: 'uom_id', type: 'int' },
		{ name: 'uom_name', type: 'string' },	
		{ name: 'adhesive_id', type: 'int' },
		{ name: 'adhesive_name', type: 'string' },	
		{ name: 'machine_id', type: 'int' },
		{ name: 'machine_name', type: 'string' },	
		{ name: 'roller_type_id', type: 'int' },
		{ name: 'roller_type_name', type: 'string' },
		{ name: 'compound_id', type: 'int' },
		{ name: 'compound_name', type: 'string' },
		{ name: 'core_builder_id', type: 'int' },
		{ name: 'core_builder_sku', type: 'string' },
		{ name: 'core_builder_name', type: 'string' },
		{ name: 'is_crowning', type: 'boolean' } , 
		{ name: 'is_grooving', type: 'boolean' },
		{ name: 'is_chamfer', type: 'boolean' },
		{ name: 'crowning_size', type: 'string' },
		{ name: 'grooving_width', type: 'string' },
		{ name: 'grooving_depth', type: 'string' },
		{ name: 'grooving_position', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/roller_builders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_builders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_builder : record.data };
				}
			}
		}
	
  
});
