require 'spec_helper'

describe PaymentVoucher do
 
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
    
    @cba = CashBankAdjustment.create_object(
        :cash_bank_id => @cb_1.id,
        :amount =>  BigDecimal("100000") ,
        :status => ADJUSTMENT_STATUS[:addition] ,
        :adjustment_date => DateTime.now  ,
        :description => nil ,
        :code => nil
      )
  
    @pi_1 = PurchaseInvoice.create_object(
      :purchase_receival_id => @pr_1.id,
      :invoice_date => DateTime.now,
      :nomor_surat => "123",
      :description => "description_1",
      :due_date => DateTime.now
      )
    
    @pid_1 = PurchaseInvoiceDetail.create_object(
      :purchase_invoice_id => @pi_1.id,
      :purchase_receival_detail_id => @prd_1.id,
      :amount => BigDecimal("10"),
      )
    
    
    @pi_1.reload
    @pi_1.confirm_object(:confirmed_at => DateTime.now)
    @cba.confirm_object(:confirmed_at => DateTime.now)
    
    @payable_1 = Payable.where(
      :source_id => @pi_1.id,
      :source_class => @pi_1.class.to_s
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
    @payment_date_1 = DateTime.now
    @payment_date_2 = DateTime.now + 1.days

  end
  
  it "cannot create payment_voucher if payment_date is not valid" do
    pv = PaymentVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :payment_date => nil,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
    @cb_1.reload
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
  
  it "cannot create payment_voucher if contact_id is not valid" do
    pv = PaymentVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :payment_date => @payment_date_1,
      :contact_id =>  12312344,
      :cash_bank_id => @cb_1.id
      )
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
  
  it "cannot create payment_voucher if cashbank_id is not valid" do
    pv = PaymentVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :payment_date => @payment_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => 123123
      )
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
  
  it "cannot create payment_voucher if is_gbch == true and cash_bank.is_bank == false" do
    pv = PaymentVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :payment_date => @payment_date_1,
      :due_date => @due_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_2.id,
      )
    pv.errors.size.should_not == 0
    pv.should_not be_valid
  end
#   GBCH TRUE
  context "create payment_voucher is_gbch true" do
    before(:each) do
    @pv = PaymentVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_1,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :payment_date => @payment_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
    end
    
    it "should update payment_voucher" do
      @pv.update_object(
        :no_bukti => @no_bukti_2,
        :is_gbch => @is_gbch_2,
        :gbch_no => @gbch_no_2,
        :due_date => @due_date_2,
        :pembulatan => @pembulatan_2,
        :status_pembulatan => @status_pembulatan_2,
        :biaya_bank => @biaya_bank_2,
        :rate_to_idr => @rate_to_idr_2,
        :payment_date => @payment_date_2,
        :contact_id =>  @ct_2.id,
        :cash_bank_id => @cb_2.id
        )
      @pv.should be_valid
      @pv.errors.size.should == 0 
      @pv.no_bukti.should == @no_bukti_2
      @pv.is_gbch.should == @is_gbch_2
      @pv.gbch_no.should == @gbch_no_2
      @pv.due_date.should == @due_date_2
      @pv.pembulatan.should == @pembulatan_2
      @pv.status_pembulatan.should == @status_pembulatan_2
      @pv.biaya_bank.should == @biaya_bank_2
      @pv.rate_to_idr.should == @rate_to_idr_2
      @pv.payment_date.should == @payment_date_2
      @pv.contact_id.should == @ct_2.id
      @pv.cash_bank_id.should == @cb_2.id     
    end
    
    it "cannot confirm payment_voucher if have no detail" do
      @pv.confirm_object(:confirmed_at => DateTime.now)
      @pv.errors.size.should_not == 0
    end
 
    context "Create PaymentVoucherDetail" do
      before(:each) do
        @pvd = PaymentVoucherDetail.create_object(
          :payment_voucher_id => @pv.id,
          :payable_id => @payable_1.id,
          :amount => BigDecimal("100000"),
          :amount_paid => BigDecimal("100000"),
          :pph_21 => BigDecimal("0"),
          :pph_23 => BigDecimal("0"),
          :rate => BigDecimal("1")
          )
        @pv.reload
        @pvd.should be_valid
      end
      
      it "should have detail and payment_voucher.amount == 100000" do
        @pv.payment_voucher_details.count.should == 1
        @pv.amount.should == BigDecimal("100000")
      end
      
      it "cannot delete payment_voucher if have detail" do
        @pv.delete_object
        @pv.errors.size.should_not == 0    
      end
      
      it "cannot update payment_voucher if have detail" do
        @pv.update_object(
          :no_bukti => @no_bukti_2,
          :is_gbch => @is_gbch_2,
          :gbch_no => @gbch_no_2,
          :due_date => @due_date_2,
          :pembulatan => @pembulatan_2,
          :status_pembulatan => @status_pembulatan_2,
          :biaya_bank => @biaya_bank_2,
          :rate_to_idr => @rate_to_idr_2,
          :payment_date => @payment_date_2,
          :contact_id =>  @ct_2.id,
          :cash_bank_id => @cb_2.id
        )
        @pv.errors.size.should_not == 0 
      end
      
      context "confirm payment_voucher" do
        before(:each) do
          @initial_payable_amount = @payable_1.amount
          @pv.confirm_object(:confirmed_at => DateTime.now)
          @cb_1.reload
          @payable_1.reload
        end
        
        it "should update each payable.remaining_amount to 0" do
          @payable_1.remaining_amount.should == 0
        end
        
        it "should create TransactionData" do
          td = TransactionData.where(
            :transaction_source_type => @pv.class.to_s,
            :transaction_source_id => @pv.id
            )
          td.count.should == 1
        end
        
        context "reconcile payment_voucher" do
          before(:each) do
            @pv.reconcile_object(:reconciliation_date => DateTime.now)
            @cb_1.reload
          end
          
          it "should reconcile payment_voucher" do
            @pv.is_reconciled.should == true
          end
          
          it "should update cashbank amount to 0" do
            @cb_1.amount.should == BigDecimal("0")
          end
          
           it "should create 2 TransactionData" do
          td = TransactionData.where(
            :transaction_source_type => @pv.class.to_s,
            :transaction_source_id => @pv.id
            )
          td.count.should == 2
        end
          
          
          context "unreconcile payment_voucher" do
            before(:each) do
              @pv.unreconcile_object
              @cb_1.reload
            end
            
            it "should unreconcile payment_voucher" do     
              @pv.is_reconciled.should == false
            end

            it "should update cashbank amount to 100000" do
              @cb_1.amount.should == BigDecimal("100000")
            end
          end
        end
        
        context "unconfirm payment_voucher" do
          before(:each) do
            @pv.unconfirm_object
            @cb_1.reload
            @payable_1.reload
          end

          it "should update each payable.remaining_amount to first amount" do
            @payable_1.remaining_amount.should ==  @initial_payable_amount
          end

          it "cannot unconfirm payment_request" do
            @pv.unconfirm_object
            @pv.errors.size.should_not == 0
          end
          
          
        end
      end
      
    end
  end
#   GBCH false
  context "Create PaymentVoucher is_gbch false" do
   before(:each) do
    @pv = PaymentVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_2,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :payment_date => @payment_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
    end
    
    context "Create PaymentVoucherDetail" do
      before(:each) do
        @pvd = PaymentVoucherDetail.create_object(
          :payment_voucher_id => @pv.id,
          :payable_id => @payable_1.id,
          :amount => BigDecimal("100000"),
          :amount_paid => BigDecimal("100000"),
          :pph_21 => BigDecimal("0"),
          :pph_23 => BigDecimal("0"),
          :rate => BigDecimal("1")
          )
        @pv.reload
      end
      
      context "confirm payment_voucher" do
        before(:each) do
          @initial_payable_amount = @payable_1.amount
          @pv.confirm_object(:confirmed_at => DateTime.now)
          @cb_1.reload
          @payable_1.reload
        end
        
        it "should update cashbank amount to 0" do
          @cb_1.amount.should == BigDecimal("0")
        end
        
        it "should create 1 transaction_data" do
          td = TransactionData.where(
            :transaction_source_type => @pv.class.to_s,
            :transaction_source_id => @pv.id
            )
          td.count.should == 1

        end
        
        it "should create 1 cash mutation" do
          cashmutation_count = CashMutation.where(
            :source_class => @pv.class.to_s, 
            :source_id => @pv.id 
          ).count
          cashmutation_count.should == 1
        end
        
        context "unconfirm payment_voucher" do
          before(:each) do
            @pv.unconfirm_object
            @cb_1.reload
            @payable_1.reload
          end

          it "should delete cash mutation" do
            cashmutation_count = CashMutation.where(
              :source_class => @pv.class.to_s, 
              :source_id => @pv.id ,
            ).count

            cashmutation_count.should == 0
          end

          it "should update each payable.remaining_amount to first amount" do
            @payable_1.remaining_amount.should ==  @initial_payable_amount
          end

          it "cannot unconfirm payment_request" do
            @pv.unconfirm_object
            @pv.errors.size.should_not == 0
          end
        end
      end
    end
  end
end
