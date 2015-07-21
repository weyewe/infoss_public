Ext.define('AM.store.PurchaseDownPayments', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PurchaseDownPayment'],
  	model: 'AM.model.PurchaseDownPayment',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 40, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
