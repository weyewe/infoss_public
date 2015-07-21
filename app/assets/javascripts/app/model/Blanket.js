Ext.define('AM.model.Blanket', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
    	{ name: 'sku', type: 'string' },
    	{ name: 'name', type: 'string' },
    	{ name: 'description', type: 'string' },
    	{ name: 'amount', type: 'string' },
    	{ name: 'contact_id', type: 'int' },
    	{ name: 'contact_name', type: 'string' },
    	{ name: 'machine_id', type: 'int' },
		{ name: 'machine_name', type: 'string' } , 
		{ name: 'adhesive_id', type: 'int' }     ,
		{ name: 'adhesive_name', type: 'string' }     ,
		{ name: 'adhesive2_id', type: 'int' }     ,
		{ name: 'adhesive2_name', type: 'string' }     ,
		{ name: 'adhesive2_name', type: 'string' }     ,
		{ name: 'roll_blanket_item_id', type: 'int' }     ,
		{ name: 'roll_blanket_item_name', type: 'string' }     ,
		{ name: 'left_bar_item_id', type: 'int' }     ,
		{ name: 'left_bar_item_name', type: 'string' }     ,
		{ name: 'right_bar_item_id', type: 'int' }     ,
		{ name: 'right_bar_item_name', type: 'string' }     ,
		{ name: 'ac', type: 'string' }     ,
		{ name: 'ar', type: 'string' }     ,
		{ name: 'thickness', type: 'string' }     ,
		{ name: 'ks', type: 'string' }     ,
		{ name: 'is_bar_required', type: 'boolean' }     ,
		{ name: 'has_left_bar', type: 'boolean' }     ,
		{ name: 'has_right_bar', type: 'boolean' }     ,
		{ name: 'cropping_type', type: 'int' }     ,
		{ name: 'left_over_ac', type: 'string' }     ,
		{ name: 'special', type: 'string' }     ,
		{ name: 'application_case', type: 'int' }     ,
		
		
		
		
		
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blankets',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blankets',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blanket : record.data };
				}
			}
		}
	
  
});
