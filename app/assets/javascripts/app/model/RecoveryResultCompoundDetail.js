Ext.define('AM.model.RecoveryResultCompoundDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

    	    { name: 'id', type: 'int' },
    	    { name: 'recovery_order_detail_id', type: 'int' },
    	    { name: 'finish_amount', type: 'int' },
    	    { name: 'defect_amount', type: 'int' },
    	    { name: 'reject_amount', type: 'int' },
			{ name: 'batch_instance_id', type: 'int' } ,
			{ name: 'batch_instance_name', type: 'string' } ,
		 
		 
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/recovery_result_compound_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'recovery_result_compound_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { recovery_result_compound_detail : record.data };
				}
			}
		}
	
  
});
