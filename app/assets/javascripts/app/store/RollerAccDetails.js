Ext.define('AM.store.RollerAccDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerAccDetail'],
  	model: 'AM.model.RollerAccDetail',
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
