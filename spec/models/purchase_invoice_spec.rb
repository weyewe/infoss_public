require 'spec_helper'

describe PurchaseInvoice do
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
    
    @po_1.confirm_object(:confirmed_at => DateTime.now) 

    @pr_1 = PurchaseReceival.create_object(
        :warehouse_id => @wrh_1.id,
        :receival_date => DateTime.now,
        :nomor_surat => "nomor_surat_1",
        :purchase_order_id => @po_1.id,
        )
    
    @prd_1 = PurchaseReceivalDetail.create_object(
        :purchase_receival_id => @pr_1.id,
        :purchase_order_detail_id => @pod_1.id,
        :amount => BigDecimal("10"),
        )
    
    @pr_1.confirm_object(:confirmed_at => DateTime.now)
    
    @invoice_date_1 = DateTime.now
    @invoice_date_2 = DateTime.now + 1.days
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
    @description_1 = "description_1"
    @description_2 = "description_2"
  end
  
  it  "should create pr" do
    @pr_1.should be_valid
  end
  
  it "should not create PurchaseInvoice if purchase_receival_id is not valid" do
    pi = PurchaseInvoice.create_object(
      :purchase_receival_id => 123123,
      :invoice_date => @invoice_date_1,
      :nomor_surat => @nomor_surat_1,
      :description => @description_1,
      :due_date => @due_date_1
      )
    pi.errors.size.should_not == 0
    pi.should_not be_valid
  end
  
it "should not create PurchaseInvoice if invoice_date is not valid" do
    pi = PurchaseInvoice.create_object(
      :purchase_receival_id => @pr_1.id,
      :invoice_date => nil,
      :nomor_surat => @nomor_surat_1,
      :description => @description_1,
      :due_date => @due_date_1
      )
    pi.errors.size.should_not == 0
    pi.should_not be_valid
  end
  
  it "should not create PurchaseInvoice if nomor_surat is not valid" do
    pi = PurchaseInvoice.create_object(
      :purchase_receival_id => @pr_1.id,
      :invoice_date => @invoice_date_1,
      :nomor_surat => nil,
      :description => @description_1,
      :due_date => @due_date_1
      )
    pi.errors.size.should_not == 0
    pi.should_not be_valid
  end

  
  context "Create PurchaseInvoice" do
    before(:each) do
      @pi = PurchaseInvoice.create_object(
        :purchase_receival_id => @pr_1.id,
        :invoice_date => @invoice_date_1,
        :nomor_surat => @nomor_surat_1,
        :description => @description_1,
        :due_date => @due_date_1
        )
    end
    
    it "should create PurchaseInvoice" do
      @pi.should be_valid
      @pi.errors.size.should == 0
      
    end
    
    it "should update PurchaseInvoice" do
      @pi.update_object(
        :purchase_receival_id => @pr_1.id,
        :invoice_date => @invoice_date_2,
        :nomor_surat => @nomor_surat_2,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @pi.purchase_receival_id.should == @pr_1.id
      @pi.invoice_date.should == @invoice_date_2
      @pi.nomor_surat.should == @nomor_surat_2
      @pi.description.should == @description_2
      @pi.due_date.should == @due_date_2
    end
    
    it "should not update PurchaseInvoice if purchase_receival_id is not valid" do
      @pi.update_object(
        :purchase_receival_id => 1231231,
        :invoice_date => @invoice_date_2,
        :nomor_surat => @nomor_surat_2,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @pi.errors.size.should_not == 0
      @pi.should_not be_valid
    end
    
    it "should not update PurchaseInvoice if invoice_date is not valid" do
      @pi.update_object(
        :purchase_receival_id => @pr_1.id,
        :invoice_date => nil,
        :nomor_surat => @nomor_surat_2,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @pi.errors.size.should_not == 0
      @pi.should_not be_valid
    end
    
    it "should not update PurchaseInvoice if nomor_surat is not valid" do
      @pi.update_object(
        :purchase_receival_id => @pr_1.id,
        :invoice_date => @invoice_date_2,
        :nomor_surat => nil,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @pi.errors.size.should_not == 0
      @pi.should_not be_valid
    end
    
    it "should delete PurchaseInvoice" do
      @pi.delete_object
      @pi.errors.size.should == 0
    end
    
    context "Create PurchaseInvoiceDetail" do
      before(:each) do
      @pid_1 = PurchaseInvoiceDetail.create_object(
        :purchase_invoice_id => @pi.id,
        :purchase_receival_detail_id => @prd_1.id,
        :amount => BigDecimal("10"),
        )
      @pi.reload
      end
      
      it "should create PurchaseInvoiceDetail" do
        @pid_1.should be_valid
        @pid_1.errors.size.should == 0
      end
      
      it "should not update PurchaseInvoice if have details" do
        @pi.update_object(
          :purchase_receival_id => @pr_1.id,
          :invoice_date => @invoice_date_2,
          :nomor_surat => @nomor_surat_2,
          :description => @description_2,
          :due_date => @due_date_2
        )
        @pi.errors.size.should_not == 0
      end

      it "should not delete PurchaseInvoice if have details" do
        @pi.delete_object
        @pi.errors.size.should_not == 0
      end
      
      context "Confirm PurchaseInvoice" do
        before(:each) do
          @pi.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm PurchaseInvoice" do
          @pi.is_confirmed.should be true
        end
        
        it "should create 1 payable" do
          payable = Payable.where(
            :source_id => @pi.id,
            :source_class => @pi.class.to_s
            )
          payable.count.should == 1
          payable.first.amount.should == @pi.amount_payable
        end
        
        it "should create TransactionData" do
          TransactionData.count.should == 2
          TransactionData.first.is_confirmed == true
        end
        
        it "should set Purchase_receival is_invoice_completed to true" do
          @pr_1.reload
          @pr_1.is_invoice_completed.should == true
        end
        
        it "should not double confirm" do
          @pi.confirm_object(:confirmed_at => DateTime.now)
          @pi.errors.size.should_not == 0
        end
        
        context "Unconfirm PurchaseInvoice" do
          before(:each) do
            @pi.unconfirm_object
          end
          
          it "should unconfirm PurchaseInvoice" do
            @pi.is_confirmed.should be false
            @pi.confirmed_at.should == nil
            @pi.errors.size.should == 0
          end
          
          it "should set Purchase_receival is_invoice_completed  to false" do
            @pr_1.reload
            @pr_1.is_invoice_completed.should == false
          end
          
          it "should delete payable" do
            payable = Payable.where(
            :source_id => @pi.id,
            :source_class => @pi.class.to_s
            )
            payable.count.should == 0
          end
          
          it "should not unconfirm again" do
            @pi.unconfirm_object
            @pi.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end
end

