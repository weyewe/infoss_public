Ext.define('AM.model.SalesDownPaymentAllocation', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    { name: 'payable_id', type: 'int' },
    	    { name: 'payable_source_code', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'allocation_date', type: 'string' },
    	    { name: 'total_amount', type: 'string' },
    	    { name: 'rate_to_idr', type: 'string' },
    	    { name: 'is_confirmed', type: 'boolean' },
    	    { name: 'confirmed_at', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_down_payment_allocations',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_down_payment_allocations',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_down_payment_allocation : record.data };
				}
			}
		}
	
  
});
