Ext.define('AM.model.PurchaseOrder', {
  	extend: 'Ext.data.Model',
  	fields: [

	 
    	    { name: 'id', type: 'int' },
    	    { name: 'purchase_date', type: 'string' },
			{ name: 'nomor_surat', type: 'string' } ,
			{ name: 'code', type: 'string' } ,
			
			{ name: 'contact_id', type: 'int' },
    	    { name: 'contact_name', type: 'string' },
    	    
    	    { name: 'exchange_id', type: 'int' },
    	    { name: 'exchange_name', type: 'string' },
			
			{ name: 'is_confirmed', type: 'boolean' } , 
			{ name: 'confirmed_at', type: 'string' }   ,
			
	 		{ name: 'allow_edit_detail', type: 'boolean' }, 
			{ name: 'allow_edit_detail_text', type: 'string' },
			
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/purchase_orders',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'purchase_orders',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { purchase_order : record.data };
				}
			}
		}
	
  
});
