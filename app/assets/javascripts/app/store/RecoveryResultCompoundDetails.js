Ext.define('AM.store.RecoveryResultCompoundDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RecoveryResultCompoundDetail'],
  	model: 'AM.model.RecoveryResultCompoundDetail',
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
