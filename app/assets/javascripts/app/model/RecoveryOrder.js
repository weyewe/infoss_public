Ext.define('AM.model.RecoveryOrder', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'roller_identification_form_id', type: 'int' },
    	    { name: 'roller_identification_form_nomor_disasembly', type: 'string' },
    	    { name: 'roller_identification_form_code', type: 'string' },
    	    { name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'amount_received', type: 'int' },
    	    { name: 'amount_rejected', type: 'int' },
    	    { name: 'amount_final', type: 'int' },
    	    { name: 'is_completed', type: 'boolean' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'confirmed_at', type: 'string' },
    	    { name: 'has_due_date', type: 'int' },
    	    { name: 'due_date', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/recovery_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'recovery_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { recovery_order : record.data };
				}
			}
		}
	
  
});
