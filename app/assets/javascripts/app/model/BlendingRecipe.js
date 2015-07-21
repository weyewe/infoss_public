Ext.define('AM.model.BlendingRecipe', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'name', type: 'string' },
			{ name: 'description', type: 'string' } ,
			
			{ name: 'target_item_id', type: 'int' },
    	    { name: 'target_item_name', type: 'string' },
    	    { name: 'target_item_sku', type: 'string' },
    	    { name: 'target_item_uom_name', type: 'string' },
    	    { name: 'target_amount', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blending_recipes',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blending_recipes',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blending_recipe : record.data };
				}
			}
		}
	
  
});
