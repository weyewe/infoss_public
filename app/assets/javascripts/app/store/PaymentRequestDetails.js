Ext.define('AM.store.PaymentRequestDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.PaymentRequestDetail'],
  	model: 'AM.model.PaymentRequestDetail',
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
