Ext.define('AM.store.RollerIdentificationForms', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerIdentificationForm'],
  	model: 'AM.model.RollerIdentificationForm',
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
