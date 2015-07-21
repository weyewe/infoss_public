Ext.define('AM.store.BankAdministrationDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.BankAdministrationDetail'],
  	model: 'AM.model.BankAdministrationDetail',
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
