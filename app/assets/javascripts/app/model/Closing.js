Ext.define('AM.model.Closing', {
  	extend: 'Ext.data.Model',
  	fields: [
    	    { name: 'id', type: 'int' },
    	    { name: 'period', type: 'int' },
			{ name: 'beginning_period', type: 'string' } ,
			{ name: 'end_date_period', type: 'string' } ,
			{ name: 'year_period', type: 'int' } ,
			{ name: 'is_year_closing', type: 'boolean' },
    	    { name: 'is_closed', type: 'boolean' },
    	    { name: 'closed_at', type: 'string' },
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/closings',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'closings',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { closing : record.data };
				}
			}
		}
	
  
});
