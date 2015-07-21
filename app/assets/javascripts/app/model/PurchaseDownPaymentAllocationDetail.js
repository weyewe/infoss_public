Ext.define('AM.model.PurchaseDownPaymentAllocationDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	         { name: 'id', type: 'int' },
    	    { name: 'purchase_down_payment_allocation_id', type: 'int' },
    	    { name: 'payable_id', type: 'int' },
    	    { name: 'payable_source_code', type: 'string' },
    	    { name: 'code', type: 'string' },
    	    { name: 'amount', type: 'string' },
    	    { name: 'amount_paid', type: 'string' },
    	    { name: 'rate', type: 'string' },
    	    { name: 'description', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_down_payment_allocation_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_down_payment_allocation_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_down_payment_allocation_detail : record.data };
				}
			}
		}
	
  
});
