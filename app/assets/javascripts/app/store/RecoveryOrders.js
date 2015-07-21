Ext.define('AM.store.RecoveryOrders', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryOrder'],
  	model: 'AM.model.RecoveryOrder',
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
