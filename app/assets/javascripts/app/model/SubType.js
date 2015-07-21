Ext.define('AM.model.SubType', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'name', type: 'string' },
			{ name: 'item_type_id', type: 'int' },
			{ name: 'item_type_name', type: 'string' },
			 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/sub_types',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sub_types',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sub_type : record.data };
				}
			}
		}
	
  
});
