Ext.define('AM.store.RollerIdentificationFormDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerIdentificationFormDetail'],
  	model: 'AM.model.RollerIdentificationFormDetail',
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
