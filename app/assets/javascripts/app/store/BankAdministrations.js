Ext.define('AM.store.BankAdministrations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BankAdministration'],
  	model: 'AM.model.BankAdministration',
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
