Ext.define('AM.model.PurchaseInvoiceDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 
	        { name: 'purchase_invoice_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
			{ name: 'code', type: 'string' } ,
			{ name: 'price', type: 'string' },
			
			{ name: 'purchase_receival_detail_id', type: 'int' },
			{ name: 'purchase_receival_detail_code', type: 'string' },
			
			{ name: 'purchase_receival_detail_purchase_order_detail_item_id', type: 'int' },
    	    { name: 'purchase_receival_detail_purchase_order_detail_item_sku', type: 'string' },
    	    { name: 'purchase_receival_detail_purchase_order_detail_item_name', type: 'string' },
    	    
    	    { name: 'purchase_receival_detail_purchase_order_detail_item_uom_id', type: 'int' },
    	    { name: 'purchase_receival_detail_purchase_order_detail_item_uom_name', type: 'string' }, 
    	    
    	    { name: 'purchase_receival_detail_purchase_order_detail_price', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_invoice_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_invoice_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_invoice_detail : record.data };
				}
			}
		}
	
  
});
