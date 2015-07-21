require 'spec_helper'

describe PurchaseReceival do
  before(:each) do
   
  @wrh_1 = Warehouse.create_object(
    :name => "whname_1" ,
    :description => "description_1",
    :code => "code_1"
    )
    
  @wrh_2 = Warehouse.create_object(
    :name => "name_2" ,
    :description => "description_1",
    :code => "code_2"
    ) 
  
  @cg_1 = ContactGroup.create_object(
    :name => "Group1" ,
    :description => "Description1"
    )
    
  @ct_1 = Contact.create_object(
    :name => "name_1" ,
    :address => "address_1",
    :delivery_address => "delivery_address_1",
    :description => "description_1",
    :npwp => "npwp_1" ,
    :contact_no => "9928321",
    :pic => "pic_1",
    :pic_contact_no => "1232133",
    :email => "email1@email.com",
    :is_taxable => true,
    :tax_code => TAX_CODE[:code_01],
    :contact_type => CONTACT_TYPE[:supplier],
    :default_payment_term => 30,
    :nama_faktur_pajak => "nama_faktur_pajak_1",
    :contact_group_id => @cg_1.id
    )

  @ct_2 = Contact.create_object(
    :name => "name_2" ,
    :address => "address_2",
    :delivery_address => "delivery_address_2",
    :description => "description_2",
    :npwp => "npwp_2" ,
    :contact_no => "9219312",
    :pic => "pic_2",
    :pic_contact_no => "123242133",
    :email => "email2@email.com",
    :is_taxable => true,
    :tax_code => TAX_CODE[:code_01],
    :contact_type => CONTACT_TYPE[:supplier],
    :default_payment_term => 30,
    :nama_faktur_pajak => "nama_faktur_pajak_1",
    :contact_group_id => @cg_1.id
    )
    
  
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
   
      )
  
    @itp_1 = ItemType.create_object(
      :name => "ItemType_1" ,
      :description => "Description1",
      :account_id => @coa_1.id
      )
    
    @sbp_1 = SubType.create_object(
      :name => "SubType_1" ,
      :item_type_id => @itp_1.id
      )
    
    @uom_1 = Uom.create_object(
      :name => "Uom_1" ,
      )
    
    @exc_1 = Exchange.create_object(
      :name => "IDR1",
      :description => "description_1",
      )
    
    @exc_2 = Exchange.create_object(
      :name => "USD",
      :description => "description_2",
      )
    
    @exr_1 = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => DateTime.now,
      :rate => BigDecimal("1")
    )
    
    
    
    @item_1 = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku1",
      :name => "itemname1",
      :description => "description_1",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("10"),
      :selling_price => BigDecimal("1000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
   
      
   @po_1 = PurchaseOrder.create_object(
      :contact_id => @ct_1.id,
      :purchase_date => DateTime.now,
      :nomor_surat => "991.22",
      :allow_edit_detail => true,
      :description => "Description1",
      :exchange_id => @exc_1.id
      )
  
   @pod_1 = PurchaseOrderDetail.create_object(
      :purchase_order_id => @po_1.id,
      :item_id => @item_1.id,
      :amount => BigDecimal("10"),
      :price => BigDecimal("10000")
      )
    
   @po_2 = PurchaseOrder.create_object(
      :contact_id => @ct_1.id,
      :purchase_date => DateTime.now,
      :nomor_surat => "991.22",
      :allow_edit_detail => true,
      :description => "Description1",
      :exchange_id => @exc_1.id
      )
  
#     @pod_2 = PurchaseOrderDetail.create_object(
#       :purchase_order_id => @po_2.id,
#       :item_id => @item_1.id,
#       :amount => BigDecimal("10"),
#       :price => BigDecimal("10000")
#       )
    
    @po_1.confirm_object(:confirmed_at => DateTime.now) 
#     @po_2.confirm_object(:confirmed_at => DateTime.now)   
    @receival_date_1 = DateTime.now
    @receival_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
  end
  
  it "should change Item Pending Receival to 10" do
    item = Item.where(:id => @pod_1.item_id)
    item.first.pending_receival.should == 10
  end
  
  it "should not create PurchaseReceival if warehouse_id is not valid" do
    pr = PurchaseReceival.create_object(
      :warehouse_id => 123123,
      :receival_date => @receival_date_1,
      :nomor_surat => @nomor_surat_1,
      :purchase_order_id => @po_1.id,
      )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  
it "should not create PurchaseReceival if receival_date is not valid" do
    pr = PurchaseReceival.create_object(
      :warehouse_id => @wrh_1.id,
      :receival_date => nil,
      :nomor_surat => @nomor_surat_1,
      :purchase_order_id => @po_1.id,
      )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  
  it "should not create PurchaseReceival if nomor_surat is not valid" do
    pr = PurchaseReceival.create_object(
      :warehouse_id => @wrh_1.id,
      :receival_date => @receival_date_1,
      :nomor_surat => nil,
      :purchase_order_id => @po_1.id,
      )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end

  it "should not create PurchaseReceival if purchase_order_id is not valid" do
    pr = PurchaseReceival.create_object(
      :warehouse_id => @wrh_1.id,
      :receival_date => @receival_date_1,
      :nomor_surat => @nomor_surat_1,
      :purchase_order_id => 213123,
      )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  
  context "Create PurchaseReceival" do
    before(:each) do
      @pr = PurchaseReceival.create_object(
        :warehouse_id => @wrh_1.id,
        :receival_date => @receival_date_1,
        :nomor_surat => @nomor_surat_1,
        :purchase_order_id => @po_1.id,
        )
    end
    
    it "should create PurchaseReceival" do
      @pr.errors.size.should == 0
      @pr.should be_valid
    end
    
    it "should update PurchaseReceival" do
      @pr.update_object(
        :warehouse_id => @wrh_2.id,
        :receival_date => @receival_date_2,
        :nomor_surat => @nomor_surat_2,
        :purchase_order_id => @po_2.id,
      )
      @pr.warehouse_id.should == @wrh_2.id
      @pr.receival_date.should == @receival_date_2
      @pr.nomor_surat.should == @nomor_surat_2
      @pr.purchase_order_id.should == @po_2.id
    end
    
    it "should not update PurchaseReceival if warehouse_id is not valid" do
      @pr.update_object(
        :warehouse_id => 1232132,
        :receival_date => @receival_date_2,
        :nomor_surat => @nomor_surat_2,
        :purchase_order_id => @po_2.id,
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
    
    it "should not update PurchaseReceival if receival_date is not valid" do
      @pr.update_object(
        :warehouse_id => @wrh_2.id,
        :receival_date => nil,
        :nomor_surat => @nomor_surat_2,
        :purchase_order_id => @po_2.id,
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
    
    it "should not update PurchaseReceival if nomor_surat is not valid" do
      @pr.update_object(
        :warehouse_id => @wrh_2.id,
        :receival_date => @receival_date_2,
        :nomor_surat => nil,
        :purchase_order_id => @po_2.id,
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
    
    it "should not update PurchaseReceival if purchase_order_id is not valid" do
      @pr.update_object(
        :warehouse_id => @wrh_2.id,
        :receival_date => @receival_date_2,
        :nomor_surat => @nomor_surat_2,
        :purchase_order_id => 123123,
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end 
    
    it "should delete PurchaseReceival" do
      @pr.delete_object
      @pr.errors.size.should == 0
    end
    
    context "Create PurchaseReceivalDetail" do
      before(:each) do
      @prd_1 = PurchaseReceivalDetail.create_object(
        :purchase_receival_id => @pr.id,
        :purchase_order_detail_id => @pod_1.id,
        :amount => BigDecimal("10"),
        )
      end
      
      it "should create PurchaseReceivalDetail" do
        @prd_1.should be_valid
        @prd_1.errors.size.should == 0
        
      end
      
      it "should not update PurchaseReceival if have details" do
        @pr.update_object(
          :warehouse_id => @wrh_2.id,
          :receival_date => @receival_date_2,
          :nomor_surat => @nomor_surat_2,
          :purchase_order_id => @po_2.id,
        )
        @pr.errors.size.should_not == 0
      end

      it "should not delete PurchaseReceival if have details" do
        @pr.delete_object
        @pr.errors.size.should_not == 0
      end
      
      context "Confirm PurchaseReceival" do
        before(:each) do
          @pr.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm PurchaseReceival" do
          @pr.is_confirmed.should be true
        end
        
        it "should change Item pending_receival amount to 0" do
          item = Item.where(:id => @prd_1.item_id)
          item.count.should == 1
          item.first.pending_receival.should == 0
        end
        
        it "should change Item amount to 10" do
          item = Item.where(:id => @prd_1.item_id)
          item.count.should == 1
          item.first.amount.should == 10
        end
        
        it "should change Item.avgprice to 10000" do
          item = Item.where(:id => @prd_1.item_id)
          item.count.should == 1
          item.first.avg_price.should == BigDecimal("10000")
        end
        
        it "should set totalCOGS to 100000" do
          @pr.total_cogs.should == 100000
          @pr.total_amount.should == 100000
        end
        
        it "should set PurchaseOrder is_receival_completed to true" do
          @po_1.reload
          @po_1.is_receival_completed.should == true
        end
        
        it "should create 2 stockmutation" do
          sm = StockMutation.where(:source_id => @pr.id,:source_class => @pr.class.to_s)
          sm.count.should == 2
        end
        
        it "should create TransactionalData" do 
            td = TransactionData.where(
            :transaction_source_type => @pr.class.to_s,
            :transaction_source_id => @pr.id
            )
            td.count.should == 1
        end
        
        it "should not double confirm" do
          @pr.confirm_object(:confirmed_at => DateTime.now)
          @pr.errors.size.should_not == 0
        end
        
        context "Unconfirm PurchaseReceival" do
          before(:each) do
            @pr.unconfirm_object
          end
          
          it "should unconfirm PurchaseReceival" do
            @pr.is_confirmed.should be false
            @pr.confirmed_at.should == nil
            @pr.errors.size.should == 0
          end
          
          it "should change Item pending_receival amount to 10" do
            item = Item.where(:id => @prd_1.item_id)
            item.first.pending_receival.should == 10
          end
          
          it "should change Item amount to 0" do
            item = Item.where(:id => @prd_1.item_id)
            item.first.amount.should == 0
          end
          
          it "should change Item_avg_price  to 0" do
            item = Item.where(:id => @prd_1.item_id)
            item.first.avg_price.should == 0
          end
          
          it "should set PurchaseOrder is_receival_completed to false" do
            @po_1.reload
            @po_1.is_receival_completed.should == false
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @pr.id,:source_class => @pr.class.to_s)
            sm.count.should == 0
          end
          
          it "should not unconfirm again" do
            @pr.unconfirm_object
            @pr.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end
end

