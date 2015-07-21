Ext.define('AM.store.CashBankMutations', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.CashBankMutation'],
  	model: 'AM.model.CashBankMutation',
  	// autoLoad: {start: 0, limit: this.pageSize},
		autoLoad : false, 
  	autoSync: false,
	pageSize : 40, 
	
	
		
		
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 

	listeners: {

	} 
});
