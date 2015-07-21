Ext.define('AM.model.SalesInvoice', {
  	extend: 'Ext.data.Model',
  	fields: [


 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'invoice_date', type: 'string' },
    	    { name: 'due_date', type: 'string' },
			{ name: 'description', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'amount_receivable', type: 'string' } ,
			{ name: 'total_cos', type: 'string' } ,
			{ name: 'tax_value', type: 'string' } ,
			{ name: 'exchange_rate_amount', type: 'string' } ,
			
			{ name: 'delivery_order_id', type: 'int' },
    	    { name: 'delivery_order_code', type: 'string' },
    	    
    	    { name: 'delivery_order_sales_order_exchange_id', type: 'int' },
    	    { name: 'delivery_order_sales_order_exchange_name', type: 'string' },
    	    
    	    { name: 'delivery_order_sales_order_contact_id', type: 'int' },
    	    { name: 'delivery_order_sales_order_contact_name', type: 'string' },
    	    { name: 'delivery_order_sales_order_contact_is_taxable', type: 'boolean' },
    	    { name: 'delivery_order_sales_order_contact_tax_code', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_invoices',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_invoices',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_invoice : record.data };
				}
			}
		}
	
  
});
