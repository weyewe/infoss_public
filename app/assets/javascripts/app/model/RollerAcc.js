Ext.define('AM.model.RollerAcc', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'roller_identification_form_id', type: 'int' },
    	    { name: 'detail_id', type: 'int' },
    	    { name: 'material_case', type: 'int' },
    	    { name: 'core_builder_id', type: 'int' },
    	    { name: 'core_builder_sku', type: 'string' },
    	    { name: 'core_builder_name', type: 'string' },
    	    { name: 'roller_type_id', type: 'int' },
    	    { name: 'roller_type_name', type: 'string' },
    	    { name: 'machine_id', type: 'int' },
    	    { name: 'machine_name', type: 'string' },
    	    { name: 'repair_request_case', type: 'int' },
    	    { name: 'repair_request_case_text', type: 'string' },
    	    { name: 'rd', type: 'string' },
    	    { name: 'cd', type: 'string' },
    	    { name: 'rl', type: 'string' },
    	    { name: 'wl', type: 'string' },
    	    { name: 'tl', type: 'string' },
    	    { name: 'is_job_scheduled', type: 'boolean' },
    	    { name: 'is_delivered', type: 'boolean' },
    	    { name: 'is_roller_built', type: 'boolean' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'confirmed_at', type: 'string' },
    	    { name: 'roller_no', type: 'string' },
    	    { name: 'gl', type: 'string' },
    	    { name: 'groove_length', type: 'string' },
    	    { name: 'groove_amount', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/roller_accs',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_accs',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_acc : record.data };
				}
			}
		}
	
  
});
