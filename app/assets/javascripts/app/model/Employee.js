Ext.define('AM.model.Employee', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
		{ name: 'address', type: 'string' },
		{ name: 'description', type: 'string' },
		{ name: 'contact_no', type: 'string' },
		{ name: 'email', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/employees',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'employees',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { employee : record.data };
				}
			}
		}
	
  
});
