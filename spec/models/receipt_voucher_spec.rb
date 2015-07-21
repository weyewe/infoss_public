require 'spec_helper'

describe ReceiptVoucher do
  before(:each) do
    
    @ep_1 = Employee.create_object(
      :name => "name1",
      :description => "description_1",
      :contact_no => "contact_no_1",
      :address => "address_1",
      :email => "email_1",
      ) 
    
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
    
    @cb_1 = CashBank.create_object(
      :name => "awesome name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true ,
      :exchange_id => @exc_1.id
      )
    
    @cb_2 = CashBank.create_object(
      :name => "awesome name2" ,
      :description => "ehaufeahifi heaw",
      :is_bank => false ,
      :exchange_id => @exc_1.id
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
    
    @sa_1 = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => DateTime.now,
      :description => @description_1
      )
     
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @item_1.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    
    @so_1 = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => DateTime.now,
      :nomor_surat => "nomor_surat_1",
      :exchange_id => @exc_1.id
      )
  
    @sod_1 = SalesOrderDetail.create_object(
      :sales_order_id => @so_1.id,
      :item_id => @item_1.id,
      :amount => BigDecimal("10"),
      :price => BigDecimal("10000"),
      :is_service => true
      )
    
    @so_2 = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => DateTime.now,
      :nomor_surat => "nomor_surat_2",
      :exchange_id => @exc_1.id
      )
    
    @sa_1.confirm_object(:confirmed_at => DateTime.now)
    
    @so_1.confirm_object(:confirmed_at => DateTime.now) 
    
    @dor = DeliveryOrder.create_object(
        :warehouse_id => @wrh_1.id,
        :delivery_date => DateTime.now,
        :nomor_surat => "nomor_surat",
        :sales_order_id => @so_1.id,
        )
    
    @dord_1 = DeliveryOrderDetail.create_object(
        :delivery_order_id => @dor.id,
        :sales_order_detail_id => @sod_1.id,
        :amount => BigDecimal("10"),
        )
    
    @dor.confirm_object(:confirmed_at => DateTime.now)
  
    @si_1 = SalesInvoice.create_object(
      :delivery_order_id => @dor.id,
      :invoice_date => DateTime.now,
      :nomor_surat => "123123",
      :description => "description",
      :due_date => DateTime.now
      )
    
    @sid_1 = SalesInvoiceDetail.create_object(
      :sales_invoice_id => @si_1.id,
      :delivery_order_detail_id => @dord_1.id,
      :amount => BigDecimal("10"),
      )
    @si_1.reload
    @si_1.confirm_object(:confirmed_at => DateTime.now)
    
    
    
    @receivable_1 = Receivable.where(
      :source_id => @si_1.id,
      :source_class => @si_1.class.to_s
      ).first
    
    @no_bukti_1 = "Nomor Bukti 1"
    @no_bukti_2 = "Nomor Bukti 2"
    @is_gbch_1 = true
    @is_gbch_2 = false
    @gbch_no_1 = "1234"
    @gbch_no_2 = "12345"
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @pembulatan_1 = BigDecimal("0")
    @pembulatan_2 = BigDecimal("0")
    @status_pembulatan_1 = STATUS_PEMBULATAN[:debet]
    @status_pembulatan_2 = STATUS_PEMBULATAN[:kredit]
    @biaya_bank_1 = BigDecimal("0")
    @biaya_bank_2 = BigDecimal("0")
    @rate_to_idr_1 = BigDecimal("1")
    @rate_to_idr_2 = BigDecimal("1000")
    @receipt_date_1 = DateTime.now
    @receipt_date_2 = DateTime.now + 1.days

  end
  
  it "cannot create receipt_voucher if receipt_date is not valid" do
    rv = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => nil,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
    @cb_1.reload
    rv.errors.size.should_not == 0
    rv.should_not be_valid
  end
  
  it "cannot create receipt_voucher if contact_id is not valid" do
    rv = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => @receipt_date_1,
      :contact_id =>  12312344,
      :cash_bank_id => @cb_1.id
      )
    rv.errors.size.should_not == 0
    rv.should_not be_valid
  end
  
  it "cannot create receipt_voucher if cashbank_id is not valid" do
    rv = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => @receipt_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => 123123
      )
    rv.errors.size.should_not == 0
    rv.should_not be_valid
  end
  
  it "cannot create receipt_voucher if is_gbch == true and cash_bank.is_bank == false" do
    rv = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => @receipt_date_1,
      :due_date => @due_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_2.id,
      )
    rv.errors.size.should_not == 0
    rv.should_not be_valid
  end
#   GBCH TRUE
  context "create receipt_voucher is_gbch true" do
    before(:each) do
    @rv = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => @receipt_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
    end
    
    it "should update receipt_voucher" do
      @rv.update_object(
        :no_bukti => @no_bukti_2,
        :is_gbch => @is_gbch_2,
        :gbch_no => @gbch_no_2,
        :due_date => @due_date_2,
        :pembulatan => @pembulatan_2,
        :status_pembulatan => @status_pembulatan_2,
        :biaya_bank => @biaya_bank_2,
        :rate_to_idr => @rate_to_idr_2,
        :receipt_date => @receipt_date_2,
        :contact_id =>  @ct_2.id,
        :cash_bank_id => @cb_2.id
        )
      @rv.should be_valid
      @rv.errors.size.should == 0 
      @rv.no_bukti.should == @no_bukti_2
      @rv.is_gbch.should == @is_gbch_2
      @rv.gbch_no.should == @gbch_no_2
      @rv.due_date.should == @due_date_2
      @rv.pembulatan.should == @pembulatan_2
      @rv.status_pembulatan.should == @status_pembulatan_2
      @rv.biaya_bank.should == @biaya_bank_2
      @rv.rate_to_idr.should == @rate_to_idr_2
      @rv.receipt_date.should == @receipt_date_2
      @rv.contact_id.should == @ct_2.id
      @rv.cash_bank_id.should == @cb_2.id     
    end
    
    it "cannot confirm receipt_voucher if have no detail" do
      @rv.confirm_object(:confirmed_at => DateTime.now)
      @rv.errors.size.should_not == 0
    end
 
    context "Create ReceiptVoucherDetail" do
      before(:each) do
        
        @rvd = ReceiptVoucherDetail.create_object(
          :receipt_voucher_id => @rv.id,
          :receivable_id => @receivable_1.id,
          :amount => BigDecimal("100000"),
          :amount_paid => BigDecimal("100000"),
          :pph_23 => BigDecimal("0"),
          :rate => BigDecimal("1")
          )
       
        @rv.reload
      end
      
      
      it "should have detail and receipt_voucher.amount == 100000" do
        @rv.receipt_voucher_details.count.should == 1
        @rv.amount.should == BigDecimal("100000")
      end
      
      it "cannot delete receipt_voucher if have detail" do
        @rv.delete_object
        @rv.errors.size.should_not == 0    
      end
      
      it "cannot update receipt_voucher if have detail" do
        @rv.update_object(
          :no_bukti => @no_bukti_2,
          :is_gbch => @is_gbch_2,
          :gbch_no => @gbch_no_2,
          :due_date => @due_date_2,
          :pembulatan => @pembulatan_2,
          :status_pembulatan => @status_pembulatan_2,
          :biaya_bank => @biaya_bank_2,
          :rate_to_idr => @rate_to_idr_2,
          :receipt_date => @receipt_date_2,
          :contact_id =>  @ct_2.id,
          :cash_bank_id => @cb_2.id
        )
        @rv.errors.size.should_not == 0 
      end
      
      context "confirm receipt_voucher" do
        before(:each) do
          @initial_receivable_amount = @receivable_1.amount
          @rv.confirm_object(:confirmed_at => DateTime.now)
          @cb_1.reload
          @receivable_1.reload
        end
        
        context "unconfirm receipt_voucher" do
          before(:each) do
            @rv.unconfirm_object
            @cb_1.reload
            @receivable_1.reload
          end
          
          it "should unconfirm" do
            @rv.is_confirmed.should == false
          end
          
          it "should update each receivable.remaining_amount to first amount" do
            @receivable_1.remaining_amount.should ==  @initial_receivable_amount
          end

          it "cannot unconfirm payment_request" do
            @rv.unconfirm_object
            @rv.errors.size.should_not == 0
          end
          
        end
        
        it "should update each receivable.remaining_amount to 0" do
          @receivable_1.remaining_amount.should == 0
        end
        
        context "reconcile receipt_voucher" do
          before(:each) do
            @rv.reconcile_object(:reconciliation_date => DateTime.now)
            @cb_1.reload
          end
          
          it "should reconcile receipt_voucher" do
            @rv.is_reconciled.should == true
          end
          
          it "should update cashbank amount to 100000" do
            @cb_1.amount.should == BigDecimal("100000")
          end
          
          context "unreconcile receipt_voucher" do
            before(:each) do
              @rv.unreconcile_object
              @cb_1.reload
            end
            
            it "should unreconcile receipt_voucher" do     
              @rv.is_reconciled.should == false
            end

            it "should update cashbank amount to 0" do
              @cb_1.amount.should == BigDecimal("0")
            end
          end
        end
        
       
      end
      
    end
  end
#   GBCH false
  context "Create ReceiptVoucher is_gbch false" do
   before(:each) do
    @rv = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_2,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => @receipt_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
    end
    
    context "Create ReceiptVoucherDetail" do
      before(:each) do
        @rvd = ReceiptVoucherDetail.create_object(
          :receipt_voucher_id => @rv.id,
          :receivable_id => @receivable_1.id,
          :amount => BigDecimal("100000"),
          :amount_paid => BigDecimal("100000"),
          :pph_23 => BigDecimal("0"),
          :rate => BigDecimal("1")
          )
        @rv.reload
      end
      
      context "confirm receipt_voucher" do
        before(:each) do
          @initial_receivable_amount = @receivable_1.amount
          @rv.confirm_object(:confirmed_at => DateTime.now)
          @cb_1.reload
          @receivable_1.reload
        end
        
        it "should update cashbank amount to 100000" do
          @cb_1.amount.should == BigDecimal("100000")
        end
        
        it "should create TransactionData" do
          td = TransactionData.where(
            :transaction_source_type => @rv.class.to_s,
            :transaction_source_id => @rv.id
            )
          td.count.should == 1
          td.first.is_confirmed == true
        end
        
        it "should create 1 cash mutation" do
          cashmutation_count = CashMutation.where(
            :source_class => @rv.class.to_s, 
            :source_id => @rv.id 
          ).count
          cashmutation_count.should == 1
        end
        
        context "unconfirm receipt_voucher" do
          before(:each) do
            @rv.unconfirm_object
            @cb_1.reload
            @receivable_1.reload
          end

          it "should delete cash mutation" do
            cashmutation_count = CashMutation.where(
              :source_class => @rv.class.to_s, 
              :source_id => @rv.id ,
            ).count

            cashmutation_count.should == 0
          end

          it "should update each receivable.remaining_amount to first amount" do
            @receivable_1.remaining_amount.should ==  @initial_receivable_amount
          end

          it "cannot unconfirm payment_request" do
            @rv.unconfirm_object
            @rv.errors.size.should_not == 0
          end
        end
      end
    end
  end
end
