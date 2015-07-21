Ext.define('AM.model.ContactGroup', {
  	extend: 'Ext.data.Model',
  	 
      
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
 
		{ name: 'description', type: 'string' },
	 
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/contact_groups',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'contact_groups',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { contact_group : record.data };
				}
			}
		}
	
  
});
