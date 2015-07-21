Ext.define('AM.store.PurchaseInvoices', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseInvoice'],
  	model: 'AM.model.PurchaseInvoice',
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
