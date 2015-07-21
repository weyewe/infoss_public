Ext.define('AM.model.RecoveryResult', {
  	extend: 'Ext.data.Model',
  	fields: [

			{ name: 'id', type: 'int' },
	         { name: 'recovery_order_id', type: 'int' },
	         { name: 'roller_identification_form_detail_id', type: 'int' },	
	         { name: 'roller_identification_form_detail_core_sku', type: 'string' },	
	         { name: 'roller_identification_form_detail_core_name', type: 'string' },	
	         { name: 'roller_builder_id', type: 'int' },	
	         { name: 'roller_builder_sku', type: 'string' },	
	         { name: 'roller_builder_name', type: 'string' },	
	         { name: 'total_cost', type: 'string' },	
	         { name: 'compound_usage', type: 'string' },	
	         { name: 'core_type_case', type: 'string' },	
	         { name: 'core_type_case_text', type: 'string' },	
	         { name: 'is_disassembled', type: 'boolean' },	
	         { name: 'is_stripped_and_glued', type: 'boolean' },	
	         { name: 'is_wrapped', type: 'boolean' },	
	         { name: 'is_vulcanized', type: 'boolean' },	
	         { name: 'is_faced_off', type: 'boolean' },	
	         { name: 'is_conventional_grinded', type: 'boolean' },	
	         { name: 'is_cnc_grinded', type: 'boolean' },	
	         { name: 'is_polished_and_gc', type: 'boolean' },	
	         { name: 'is_packaged', type: 'boolean' },	
	         { name: 'is_rejected', type: 'boolean' },	
	         { name: 'is_rejected', type: 'boolean' },	
	         { name: 'rejected_date', type: 'string' },	
	         { name: 'is_finished', type: 'boolean' },	
	         { name: 'finished_date', type: 'string' },	
	         { name: 'accessories_cost', type: 'string' },	
	         { name: 'core_cost', type: 'string' },	
	         { name: 'compound_cost', type: 'string' },	
	         { name: 'compound_under_layer_id', type: 'int' },	
	         { name: 'compound_under_layer_name', type: 'string' },	
	         { name: 'compound_under_layer_usage', type: 'string' },
	         
	         { name: 'roller_builder_compound_name', type: 'string' },
	         { name: 'roller_builder_compound_sku', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/recovery_results',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'recovery_results',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { recovery_result : record.data };
				}
			}
		}
	
  
});
