Ext.define('AM.store.SalesDownPayments', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.SalesDownPayment'],
  	model: 'AM.model.SalesDownPayment',
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
