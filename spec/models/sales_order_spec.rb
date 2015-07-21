require 'spec_helper'

describe SalesOrder do
  before(:each) do  
  @ep_1 = Employee.create_object(
    :name => "name1",
    :description => "description_1",
    :contact_no => "contact_no_1",
    :address => "address_1",
    :email => "email_1",
    ) 

  @ep_2 = Employee.create_object(
    :name => "name_2",
    :description => "description_2",
    :contact_no => "contact_no_2",
    :address => "address_2",
    :email => "email_2",
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
    @sales_date_1 = DateTime.now
    @sales_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
    @allow_edit_detail_1 = true
    @allow_edit_detail_2 = false
  end

  it "should not create SalesOrder if contact_id is not valid" do
    so = SalesOrder.create_object(
      :contact_id => 123123,
      :employee_id => @ep_1.id,
      :sales_date => @sales_date_1,
      :nomor_surat => @nomor_surat_1,
      :exchange_id => @exc_1.id
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  it "should not create SalesOrder if sales_date is not valid" do
    so = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => nil,
      :nomor_surat => @nomor_surat_1,
      :exchange_id => @exc_1.id
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  it "should not create SalesOrder if nomor_surat is not valid" do
    so = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => @sales_date_1,
      :nomor_surat => nil,
      :exchange_id => @exc_1.id
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end

  it "should not create SalesOrder if exchange_id is not valid" do
    so = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => @sales_date_1,
      :nomor_surat => @nomor_surat_1,
      :exchange_id => nil
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  it "should not create SalesOrder if employee_id is not valid" do
    so = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => 123123,
      :sales_date => @sales_date_1,
      :nomor_surat => @nomor_surat_1,
      :exchange_id => @exc_1.id
      )
    so.errors.size.should_not == 0
    so.should_not be_valid
  end
  
  context "Create SalesOrder" do
    before(:each) do
      @so = SalesOrder.create_object(
        :contact_id => @ct_1.id,
        :employee_id => @ep_1.id,
        :sales_date => @sales_date_1,
        :nomor_surat => @nomor_surat_1,
        :exchange_id => @exc_1.id
        )
    end
    
    it "should create SalesOrder" do
      @so.errors.size.should == 0
      @so.should be_valid
    end
    
    it "should update SalesOrder" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :employee_id => @ep_2.id,
        :sales_date => @sales_date_2,
        :nomor_surat => @nomor_surat_2,
        :exchange_id => @exc_2.id
      )
      @so.contact_id.should == @ct_2.id
      @so.sales_date.should == @sales_date_2
      @so.nomor_surat.should == @nomor_surat_2
      @so.employee_id.should == @ep_2.id
      @so.exchange_id.should == @exc_2.id
    end
    
    it "should not update SalesOrder if contact_id is not valid" do
      @so.update_object(
        :contact_id => 123123,
        :employee_id => @ep_2.id,
        :sales_date => @sales_date_2,
        :nomor_surat => @nomor_surat_2,
        :exchange_id => @exc_2.id
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end
    
    it "should not update SalesOrder if sales_date is not valid" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :employee_id => @ep_2.id,
        :sales_date => nil,
        :nomor_surat => @nomor_surat_2,
        :exchange_id => @exc_2.id
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end
    
    it "should not update SalesOrder if nomor_surat is not valid" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :employee_id => @ep_2.id,
        :sales_date => @sales_date_2,
        :nomor_surat => nil,
        :exchange_id => @exc_2.id
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end
    
    it "should not update SalesOrder if exchange_id is not valid" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :employee_id => @ep_2.id,
        :sales_date => @sales_date_2,
        :nomor_surat => @nomor_surat_2,
        :exchange_id => 123213
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end 
    
    it "should not update SalesOrder if employee_id is not valid" do
      @so.update_object(
        :contact_id => @ct_2.id,
        :employee_id => 12312,
        :sales_date => @sales_date_2,
        :nomor_surat => @nomor_surat_2,
        :exchange_id => @exc_2.id
      )
      @so.errors.size.should_not == 0
      @so.should_not be_valid
    end 
    
    
    it "should delete SalesOrder" do
      @so.delete_object
      @so.errors.size.should == 0
    end
    
    context "Create SalesOrderDetail" do
      before(:each) do
      @sod_1 = SalesOrderDetail.create_object(
        :sales_order_id => @so.id,
        :item_id => @item_1.id,
        :amount => BigDecimal("10"),
        :price => BigDecimal("10000"),
        :is_service => true
        )
      @item_1.reload
      end
      
      it "should create SalesOrderDetail" do
        @sod_1.should be_valid
        @sod_1.errors.size.should == 0
        
      end
      
      it "should not update SalesOrder if have details" do
        @so.update_object(
          :contact_id => @ct_2.id,
          :employee_id => @ep_2.id,
          :sales_date => @sales_date_2,
          :nomor_surat => @nomor_surat_2,
          :exchange_id => @exc_2.id
          )
        @so.errors.size.should_not == 0
      end

      it "should not delete SalesOrder if have details" do
        @so.delete_object
        @so.errors.size.should_not == 0
      end
      
      context "Confirm SalesOrder" do
        before(:each) do
          @so.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm SalesOrder" do
          @so.is_confirmed.should be true
        end
        
        it "should change Item delivery amount to 10" do
          item = Item.where(:id => @sod_1.item_id)
          item.count.should == 1
          item.first.pending_delivery.should == @sod_1.amount
        end
        
        it "should create 1 stockmutation" do
          sm = StockMutation.where(:source_id => @so.id,:source_class => @so.class.to_s)
          sm.count.should == 1
        end
        
        it "should not double confirm" do
          @so.confirm_object(:confirmed_at => DateTime.now)
          @so.errors.size.should_not == 0
        end
        
        context "Unconfirm SalesOrder" do
          before(:each) do
            @so.unconfirm_object
          end
          
          it "should unconfirm SalesOrder" do
            @so.is_confirmed.should be false
            @so.confirmed_at.should == nil
            @so.errors.size.should == 0
          end
          
          it "should change Item pending_delivery amount to zero" do
            item = Item.where(:id => @sod_1.item_id)
            item.first.pending_delivery.should == 0
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @so.id,:source_class => @so.class.to_s)
            sm.count.should == 0
          end
          
          it "should not unconfirm again" do
            @so.unconfirm_object
            @so.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end
end
