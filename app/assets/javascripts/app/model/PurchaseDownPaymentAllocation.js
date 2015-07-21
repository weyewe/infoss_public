Ext.define('AM.model.PurchaseDownPaymentAllocation', {
  	extend: 'Ext.data.Model',
  	fields: [

    	   { name: 'id', type: 'int' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    { name: 'receivable_id', type: 'int' },
    	    { name: 'receivable_source_code', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'allocation_date', type: 'string' },
    	    { name: 'total_amount', type: 'string' },
    	    { name: 'rate_to_idr', type: 'string' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'confirmed_at', type: 'string' },
			
			
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_down_payment_allocations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_down_payment_allocations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_down_payment_allocation : record.data };
				}
			}
		}
	
  
});
