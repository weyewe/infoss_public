Ext.define('AM.store.SalesDownPaymentAllocationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesDownPaymentAllocationDetail'],
  	model: 'AM.model.SalesDownPaymentAllocationDetail',
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
