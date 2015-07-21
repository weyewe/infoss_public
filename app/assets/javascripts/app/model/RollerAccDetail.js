Ext.define('AM.model.RollerAccDetail', {
  	extend: 'Ext.data.Model',
  	fields: [
 

	        { name: 'roller_identification_form_detail_id', type: 'int' }, 
	 
    	    { name: 'id', type: 'int' },
    	    { name: 'amount', type: 'int' },
			{ name: 'item_id', type: 'int' },
    	    { name: 'item_sku', type: 'string' },
    	    { name: 'item_name', type: 'string' },
			
  	],

	 


   
  	idProperty: 'id' ,

		proxy: {
			url: 'api/roller_accessory_details',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'roller_accessory_details',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { roller_acc_detail : record.data };
				}
			}
		}
	
  
});
