Ext.define('AM.store.RecoveryWorkProcessDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryWorkProcessDetail'],
  	model: 'AM.model.RecoveryWorkProcessDetail',
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
