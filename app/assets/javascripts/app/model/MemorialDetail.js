Ext.define('AM.model.MemorialDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
	        { name: 'memorial_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
			{ name: 'code', type: 'string' } ,
			{ name: 'account_id', type: 'int' } ,
			{ name: 'account_code', type: 'string' } ,
			{ name: 'account_name', type: 'string' } ,
			{ name: 'status', type: 'string' } ,
			{ name: 'status_text', type: 'string' } ,
			{ name: 'amount', type: 'string' } ,
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/memorial_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'memorial_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { memorial_detail : record.data };
				}
			}
		}
	
  
});
