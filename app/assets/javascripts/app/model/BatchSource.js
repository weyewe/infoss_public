Ext.define('AM.model.BatchSource', {
  	extend: 'Ext.data.Model',
  	fields: [

 
	
    	    { name: 'id', type: 'int' },
    	    { name: 'item_id', type: 'int' },
			{ name: 'item_sku', type: 'string' } ,
			{ name: 'item_name', type: 'string' } ,
			
			{ name: 'source_id', type: 'int' },
    	    { name: 'source_class', type: 'string' },
    	    
    	    { name: 'amount', type: 'string' },
    	    { name: 'unallocated_amount', type: 'string' },
    	    { name: 'generated_date', type: 'string' },
    	    
    	    { name: 'status', type: 'int' },
    	    { name: 'status_text', type: 'string' },
			 
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/batch_sources',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'batch_sources',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { batch_source : record.data };
				}
			}
		}
	
  
});
