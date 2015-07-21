Ext.define('AM.model.RollerIdentificationForm', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'code', type: 'string' },
    	    { name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
    	    { name: 'nomor_disasembly', type: 'string' },
    	    { name: 'incoming_roll', type: 'string' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    { name: 'is_in_house', type: 'boolean' },
    	    { name: 'amount', type: 'int' },
    	    { name: 'identified_date', type: 'string' },
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'is_completed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/roller_identification_forms',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_identification_forms',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_identification_form : record.data };
				}
			}
		}
	
  
});
