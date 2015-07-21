Ext.define('AM.model.RecoveryWorkProcessDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'recover_order_detail_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'int' },
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/recovery_accessory_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'recovery_accessory_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { recovery_work_process_detail : record.data };
				}
			}
		}
	
  
});
