Ext.define('AM.store.SalesDownPaymentAllocations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesDownPaymentAllocation'],
  	model: 'AM.model.SalesDownPaymentAllocation',
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
