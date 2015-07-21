Ext.define('AM.store.SalesInvoiceDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesInvoiceDetail'],
  	model: 'AM.model.SalesInvoiceDetail',
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
