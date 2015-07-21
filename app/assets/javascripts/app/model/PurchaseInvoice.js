Ext.define('AM.model.PurchaseInvoice', {
  	extend: 'Ext.data.Model',
  	fields: [

    	    { name: 'id', type: 'int' },
    	    { name: 'invoice_date', type: 'string' },
    	    { name: 'due_date', type: 'string' },
			{ name: 'description', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'amount_payable', type: 'string' } ,
			{ name: 'total_cos', type: 'string' } ,
			{ name: 'tax_value', type: 'string' } ,
			
			{ name: 'purchase_receival_id', type: 'int' },
    	    { name: 'purchase_receival_code', type: 'string' },
    	    
    	    { name: 'purchase_receival_purchase_order_exchange_id', type: 'int' },
    	    { name: 'purchase_receival_purchase_order_exchange_name', type: 'string' },
    	    
    	    { name: 'purchase_receival_purchase_order_contact_id', type: 'int' },
    	    { name: 'purchase_receival_purchase_order_contact_name', type: 'string' },
    	    { name: 'purchase_receival_purchase_order_contact_is_taxable', type: 'boolean' },
    	    { name: 'purchase_receival_purchase_order_contact_tax_code', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_invoices',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_invoices',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_invoice : record.data };
				}
			}
		}
	
  
});
