Ext.define('AM.store.RollerAccs', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.RollerAcc'],
  	model: 'AM.model.RollerAcc',
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
