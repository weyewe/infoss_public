Ext.define('AM.model.SalesInvoiceDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
	        { name: 'sales_invoice_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
			{ name: 'code', type: 'string' } ,
			{ name: 'price', type: 'string' },
			
			{ name: 'delivery_order_detail_id', type: 'int' },
			{ name: 'delivery_order_detail_code', type: 'string' },
			
			{ name: 'delivery_order_detail_sales_order_detail_item_id', type: 'int' },
    	    { name: 'delivery_order_detail_sales_order_detail_item_sku', type: 'string' },
    	    { name: 'delivery_order_detail_sales_order_detail_item_name', type: 'string' },
    	    
    	    { name: 'delivery_order_detail_sales_order_detail_item_uom_id', type: 'int' },
    	    { name: 'delivery_order_detail_sales_order_detail_item_uom_name', type: 'string' }, 
    	    
    	    { name: 'delivery_order_detail_sales_order_detail_price', type: 'string' }, 
    	    { name: 'delivery_order_detail_sales_order_detail_is_service', type: 'boolean' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/sales_invoice_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'sales_invoice_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { sales_invoice_detail : record.data };
				}
			}
		}
	
  
});
