Ext.define('AM.model.BlanketOrder', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
			{ name: 'warehouse_id', type: 'int' } ,
			{ name: 'warehouse_name', type: 'string' } ,	
			{ name: 'code', type: 'string' } ,	
			{ name: 'amount_received', type: 'string' } ,	
			{ name: 'amount_rejected', type: 'string' } ,	
			{ name: 'amount_final', type: 'string' } ,	
			{ name: 'production_no', type: 'string' } ,	
			{ name: 'order_date', type: 'string' } ,	
			{ name: 'notes', type: 'string' } ,	
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'is_completed', type: 'boolean' } ,	
			{ name: 'has_due_date', type: 'boolean' } ,	
			{ name: 'confirmed_at', type: 'string' }   ,
			{ name: 'due_date', type: 'string' } ,	
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/blanket_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'blanket_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { blanket_order : record.data };
				}
			}
		}
	
  
});
