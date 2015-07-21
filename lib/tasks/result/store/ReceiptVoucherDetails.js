Ext.define('AM.store.ReceiptVoucherDetails', {
  	extend: 'Ext.data.Store',
		require : ['AM.model.ReceiptVoucherDetail'],
  	model: 'AM.model.ReceiptVoucherDetail',
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
