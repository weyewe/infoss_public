Ext.define('AM.store.PurchaseInvoiceDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseInvoiceDetail'],
  	model: 'AM.model.PurchaseInvoiceDetail',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 20, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
