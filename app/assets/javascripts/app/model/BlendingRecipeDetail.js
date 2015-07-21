Ext.define('AM.model.BlendingRecipeDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'blending_recipe_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
			{ name: 'item_name', type: 'string' } ,
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
    	    
	  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blending_recipe_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blending_recipe_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blending_recipe_detail : record.data };
				}
			}
		}
	
  
});
