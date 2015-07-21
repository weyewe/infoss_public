Ext.define('AM.model.BatchSourceDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
  
	
 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'status', type: 'int' },
			{ name: 'status_text', type: 'string' } ,
			{ name: 'batch_instance_id', type: 'int' } ,
			
			{ name: 'batch_source_id', type: 'int' },
    	    { name: 'batch_instance_name', type: 'string' }, 
    	    
    	    { name: 'batch_instance_total_allocated_amount', type: 'string' }, 
    	    { name: 'batch_instance_amount', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/batch_source_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'batch_source_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { batch_source_detail : record.data };
				}
			}
		}
	
  
});
