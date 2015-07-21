Ext.define('AM.store.PurchaseOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseOrderDetail'],
  	model: 'AM.model.PurchaseOrderDetail',
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
