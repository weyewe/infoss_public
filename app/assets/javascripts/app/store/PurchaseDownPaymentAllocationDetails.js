Ext.define('AM.store.PurchaseDownPaymentAllocationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseDownPaymentAllocationDetail'],
  	model: 'AM.model.PurchaseDownPaymentAllocationDetail',
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
