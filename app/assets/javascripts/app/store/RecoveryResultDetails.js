Ext.define('AM.store.RecoveryResultDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryResultDetail'],
  	model: 'AM.model.RecoveryResultDetail',
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
