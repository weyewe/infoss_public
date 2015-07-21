Ext.define('AM.store.RecoveryOrderDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryOrderDetail'],
  	model: 'AM.model.RecoveryOrderDetail',
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
