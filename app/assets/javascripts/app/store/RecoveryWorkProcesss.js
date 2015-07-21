Ext.define('AM.store.RecoveryWorkProcesss', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryWorkProcess'],
  	model: 'AM.model.RecoveryWorkProcess',
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
