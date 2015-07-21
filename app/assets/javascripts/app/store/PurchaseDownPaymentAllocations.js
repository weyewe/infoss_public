Ext.define('AM.store.PurchaseDownPaymentAllocations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseDownPaymentAllocation'],
  	model: 'AM.model.PurchaseDownPaymentAllocation',
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
