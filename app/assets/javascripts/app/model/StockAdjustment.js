Ext.define('AM.model.StockAdjustment', {
  	extend: 'Ext.data.Model',
  	fields: [


    	    { name: 'id', type: 'int' },
    	    { name: 'adjustment_date', type: 'string' },
			{ name: 'description', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'warehouse_id', type: 'int' },
    	    { name: 'warehouse_name', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
 
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/stock_adjustments',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'stock_adjustments',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { stock_adjustment : record.data };
				}
			}
		}
	
  
});
