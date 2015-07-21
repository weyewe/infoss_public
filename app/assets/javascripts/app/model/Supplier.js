
Ext.define('AM.model.Supplier', {
  	extend: 'Ext.data.Model',
  	 
      
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'name', type: 'string' },
		{ name: 'address', type: 'string' },
		{ name: 'delivery_address', type: 'string' },
		{ name: 'description', type: 'string' },
		{ name: 'npwp', type: 'string' },
		{ name: 'contact_no', type: 'string' },
		
		{ name: 'pic', type: 'string' },
		{ name: 'pic_contact_no', type: 'string' },
		{ name: 'email', type: 'string' },
		{ name: 'is_taxable', type: 'boolean' },
		{ name: 'tax_code', type: 'string' },
		{ name: 'contact_type', type: 'string' },
		
		{ name: 'default_payment_term', type: 'int' },
		{ name: 'nama_faktur_pajak', type: 'string' },
		{ name: 'contact_group_id', type: 'int' },
		{ name: 'contact_group_name', type: 'string' },
		
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/suppliers',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'suppliers',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { supplier : record.data };
				}
			}
		}
	
  
});
