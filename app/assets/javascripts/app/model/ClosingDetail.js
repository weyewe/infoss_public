Ext.define('AM.model.ClosingDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'closing_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'exchange_id', type: 'int' },
    	    { name: 'exchange_name', type: 'string' },
    	    { name: 'rate', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/closing_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'closing_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { closing_detail : record.data };
				}
			}
		}
	
  
});
