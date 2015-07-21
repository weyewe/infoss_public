Ext.define('AM.model.StockAdjustmentDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	
	        { name: 'stock_adjustment_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'string' },
			{ name: 'price', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
    	    
    	    { name: 'item_uom_id', type: 'int' },
    	    { name: 'item_uom_name', type: 'string' }, 
    	    { name: 'status', type: 'int' }, 
    	    { name: 'status_text', type: 'string' }, 
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/stock_adjustment_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'stock_adjustment_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { stock_adjustment_detail : record.data };
				}
			}
		}
	
  
});
