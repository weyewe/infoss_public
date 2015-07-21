require 'spec_helper'

describe PurchaseOrder do

  before(:each) do  
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
    @purchase_date_1 = DateTime.now
    @purchase_date_2 = DateTime.now + 1.days
    @description_1 = "Description1"
    @description_2 = "Description2"
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
    @allow_edit_detail_1 = true
    @allow_edit_detail_2 = false
  end

  it "should not create PurchaseOrder if contact_id is not valid" do
    po = PurchaseOrder.create_object(
      :contact_id => 1231213,
      :purchase_date => @purchase_date_1,
      :nomor_surat => @nomor_surat_1,
      :allow_edit_detail => @allow_edit_detail_1,
      :description => @description_1,
      :exchange_id => @exc_1.id
      )
    po.errors.size.should_not == 0
    po.should_not be_valid
  end
  
  it "should not create PurchaseOrder if purchase_date is not valid" do
    po = PurchaseOrder.create_object(
      :contact_id => @ct_1.id,
      :purchase_date => nil,
      :nomor_surat => @nomor_surat_1,
      :allow_edit_detail => @allow_edit_detail_1,
      :description => @description_1,
      :exchange_id => @exc_1.id
      )
    po.errors.size.should_not == 0
    po.should_not be_valid
  end
  
  it "should not create PurchaseOrder if nomor_surat is not valid" do
    po = PurchaseOrder.create_object(
      :contact_id => @ct_1.id,
      :purchase_date => @purchase_date_1,
      :nomor_surat => nil,
      :allow_edit_detail => @allow_edit_detail_1,
      :description => @description_1,
      :exchange_id => @exc_1.id
      )
    po.errors.size.should_not == 0
    po.should_not be_valid
  end

  it "should not create PurchaseOrder if exchange_id is not valid" do
    po = PurchaseOrder.create_object(
      :contact_id => @ct_1.id,
      :purchase_date => @purchase_date_1,
      :nomor_surat => @nomor_surat_1,
      :allow_edit_detail => @allow_edit_detail_1,
      :description => @description_1,
      :exchange_id => nil
      )
    po.errors.size.should_not == 0
    po.should_not be_valid
  end
  
  context "Create PurchaseOrder" do
    before(:each) do
      @po = PurchaseOrder.create_object(
        :contact_id => @ct_1.id,
        :purchase_date => @purchase_date_1,
        :nomor_surat => @nomor_surat_1,
        :allow_edit_detail => @allow_edit_detail_1,
        :description => @description_1,
        :exchange_id => @exc_1.id
        )
    end
    
    it "should create PurchaseOrder" do
      @po.errors.size.should == 0
      @po.should be_valid
    end
    
    it "should update PurchaseOrder" do
      @po.update_object(
        :contact_id => @ct_2.id,
        :purchase_date => @purchase_date_2,
        :nomor_surat => @nomor_surat_2,
        :allow_edit_detail => @allow_edit_detail_2,
        :description => @description_2,
        :exchange_id => @exc_2.id
      )
      @po.contact_id.should == @ct_2.id
      @po.purchase_date.should == @purchase_date_2
      @po.nomor_surat.should == @nomor_surat_2
      @po.allow_edit_detail.should == @allow_edit_detail_2
      @po.description.should == @description_2
      @po.exchange_id.should == @exc_2.id
    end
    
    it "should not update PurchaseOrder if contact_id is not valid" do
      @po.update_object(
        :contact_id => nil,
        :purchase_date => @purchase_date_2,
        :nomor_surat => @nomor_surat_2,
        :allow_edit_detail => @allow_edit_detail_2,
        :description => @description_2,
        :exchange_id => @exc_2.id
      )
      @po.errors.size.should_not == 0
      @po.should_not be_valid
    end
    
    it "should not update PurchaseOrder if purchase_date is not valid" do
      @po.update_object(
        :contact_id => @ct_2.id,
        :purchase_date => nil,
        :nomor_surat => @nomor_surat_2,
        :allow_edit_detail => @allow_edit_detail_2,
        :description => @description_2,
        :exchange_id => @exc_2.id
      )
      @po.errors.size.should_not == 0
      @po.should_not be_valid
    end
    
    it "should not update PurchaseOrder if nomor_surat is not valid" do
      @po.update_object(
        :contact_id => @ct_2.id,
        :purchase_date => @purchase_date_2,
        :nomor_surat => nil,
        :allow_edit_detail => @allow_edit_detail_2,
        :description => @description_2,
        :exchange_id => @exc_2.id
      )
      @po.errors.size.should_not == 0
      @po.should_not be_valid
    end
    
    it "should not update PurchaseOrder if exchange_id is not valid" do
      @po.update_object(
        :contact_id => @ct_2.id,
        :purchase_date => @purchase_date_2,
        :nomor_surat => @nomor_surat_2,
        :allow_edit_detail => @allow_edit_detail_2,
        :description => @description_2,
        :exchange_id => 21312312
      )
      @po.errors.size.should_not == 0
      @po.should_not be_valid
    end 
    
    it "should delete PurchaseOrder" do
      @po.delete_object
      @po.errors.size.should == 0
    end
    
    context "Create PurchaseOrderDetail" do
      before(:each) do
      @pod_1 = PurchaseOrderDetail.create_object(
        :purchase_order_id => @po.id,
        :item_id => @item_1.id,
        :amount => BigDecimal("10"),
        :price => BigDecimal("10000")
        )
      @item_1.reload
      end
      
      it "should create PurchaseOrderDetail" do
        @pod_1.should be_valid
        @pod_1.errors.size.should == 0
        
      end
      
      it "should not update PurchaseOrder if have details" do
        @po.update_object(
          :contact_id => @ct_2.id,
          :purchase_date => @purchase_date_2,
          :nomor_surat => @nomor_surat_2,
          :allow_edit_detail => @allow_edit_detail_2,
          :description => @description_2,
          :exchange_id => @exc_2.id
        )
        @po.errors.size.should_not == 0
      end

      it "should not delete PurchaseOrder if have details" do
        @po.delete_object
        @po.errors.size.should_not == 0
      end
      
      context "Confirm PurchaseOrder" do
        before(:each) do
          @po.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm PurchaseOrder" do
          @po.is_confirmed.should be true
        end
        
        it "should change Item pending_receival amount to 10" do
          item = Item.where(:id => @pod_1.item_id)
          item.count.should == 1
          item.first.pending_receival.should == @pod_1.amount
        end
        
        it "should create 1 stockmutation" do
          sm = StockMutation.where(:source_id => @po.id,:source_class => @po.class.to_s)
          sm.count.should == 1
        end
        
        it "should not double confirm" do
          @po.confirm_object(:confirmed_at => DateTime.now)
          @po.errors.size.should_not == 0
        end
        
        context "Unconfirm PurchaseOrder" do
          before(:each) do
            @po.unconfirm_object
          end
          
          it "should unconfirm PurchaseOrder" do
            @po.is_confirmed.should be false
            @po.confirmed_at.should == nil
            @po.errors.size.should == 0
          end
          
          it "should change Item pending_receival amount to zero" do
            item = Item.where(:id => @pod_1.item_id)
            item.first.pending_receival.should == 0
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @po.id,:source_class => @po.class.to_s)
            sm.count.should == 0
          end
          
          it "should not unconfirm again" do
            @po.unconfirm_object
            @po.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end
end

 