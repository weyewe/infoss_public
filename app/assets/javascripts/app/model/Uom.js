
Ext.define('AM.model.Uom', {
  	extend: 'Ext.data.Model',
  	 
      
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
 
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/uoms',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'uoms',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { uom : record.data };
				}
			}
		}
	
  
});
