Ext.define('AM.store.SalesInvoices', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesInvoice'],
  	model: 'AM.model.SalesInvoice',
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
