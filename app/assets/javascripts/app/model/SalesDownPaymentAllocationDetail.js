Ext.define('AM.model.SalesDownPaymentAllocationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	         { name: 'id', type: 'int' },
    	    { name: 'sales_down_payment_allocation_id', type: 'int' },
    	    { name: 'receivable_id', type: 'int' },
    	    { name: 'receivable_source_code', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'amount_paid', type: 'string' },
    	    { name: 'rate', type: 'string' },
    	    { name: 'description', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_down_payment_allocation_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_down_payment_allocation_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_down_payment_allocation_detail : record.data };
				}
			}
		}
	
  
});
