Ext.define('AM.model.RecoveryResultDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'recovery_order_detail_id', type: 'int' }, 
	 
    	    { name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    { name: 'amount', type: 'string' }, 
    	    { name: 'item_uom_name', type: 'string' }, 
    	    
    	    
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/recovery_result_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'recovery_result_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { recovery_result_detail : record.data };
				}
			}
		}
	
  
});
