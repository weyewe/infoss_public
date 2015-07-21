Ext.define('AM.model.BlanketResultDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
    	    { name: 'id', type: 'int' },
    	    { name: 'blanket_order_detail_id', type: 'int' },
    	    { name: 'finish_amount', type: 'int' },
    	    { name: 'defect_amount', type: 'int' },
    	    { name: 'reject_amount', type: 'int' },
			{ name: 'batch_instance_id', type: 'int' } ,
			{ name: 'batch_instance_name', type: 'string' } ,
		 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blanket_result_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blanket_result_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blanket_result_detail : record.data };
				}
			}
		}
	
  
});
