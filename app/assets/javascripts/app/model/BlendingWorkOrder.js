Ext.define('AM.model.BlendingWorkOrder', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'code', type: 'string' }     ,
		{ name: 'description', type: 'string' }     ,
		{ name: 'blending_recipe_id', type: 'int' }     ,
		{ name: 'blending_recipe_name', type: 'string' }     ,
		{ name: 'blending_recipe_target_item_sku', type: 'string' }     ,
		{ name: 'blending_recipe_target_item_name', type: 'string' }     ,
		{ name: 'blending_recipe_target_item_uom_name', type: 'string' }     ,
		{ name: 'blending_recipe_target_amount', type: 'string' }     ,
		{ name: 'blending_date', type: 'string' }     ,
		{ name: 'warehouse_id', type: 'int' }     ,
		{ name: 'warehouse_name', type: 'string' }     ,
		{ name: 'is_confirmed', type: 'boolean' }     ,
		{ name: 'confirmed_at', type: 'string' }     ,
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blending_work_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blending_work_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blending_work_order : record.data };
				}
			}
		}
	
  
});
