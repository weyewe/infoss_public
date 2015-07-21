Ext.define('AM.store.RecoveryResults', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryResult'],
  	model: 'AM.model.RecoveryResult',
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
