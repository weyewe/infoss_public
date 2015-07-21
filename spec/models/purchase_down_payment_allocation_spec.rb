require 'spec_helper'

describe PurchaseDownPaymentAllocation do
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
    
    @exr_2 = ExchangeRate.create_object(
      :exchange_id => @exc_2.id,
      :ex_rate_date => DateTime.now,
      :rate => BigDecimal("1")
      )
    
    @coa_1 = Account.create_object(
      :code => "1110101",
      :name => "KAS 212",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )

    @coa_2 = Account.create_object(
      :code => "111220101",
      :name => "BANK 12",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:beban_usaha][:code]).id
      )
    
    @pr = PaymentRequest.create_object(
        :contact_id => @ct_1.id,
        :request_date => DateTime.now,
        :due_date => DateTime.now,
        :account_id => @coa_1.id
        )
    
    @prd = PaymentRequestDetail.create_object(
          :payment_request_id => @pr.id,
          :account_id => @coa_1.id,
          :status => STATUS_ACCOUNT[:debet],
          :amount => BigDecimal("100000"),
          )
    @pr.confirm_object(:confirmed_at => DateTime.now)      
    
    @payable = Payable.where(
            :source_id => @pr.id,
            :source_class => @pr.class.to_s,
            ).first
    
    @down_payment_date_1 = DateTime.now
    @down_payment_date_2 = DateTime.now + 1.days
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @total_amount_1 = BigDecimal("10000")
    @total_amount_2 = BigDecimal("20000")
    @description_1 = "desc"
    @allocation_date_1 = DateTime.now
    @allocation_date_2 = DateTime.now + 1.days
    @rate_to_idr_1 = BigDecimal("1")
    @rate_to_idr_1 = BigDecimal("10")
    @rate_1 = BigDecimal("1")
    @rate_2 = BigDecimal("10")
    @amount_paid_1 = BigDecimal("50000")
    @sdp = PurchaseDownPayment.create_object(
        :contact_id => @ct_1.id,
        :exchange_id => @exc_1.id,
        :down_payment_date => @down_payment_date_1,
        :due_date => @due_date_1,
        :total_amount => @total_amount_1 
        )
    @sdp.confirm_object(:confirmed_at => DateTime.now)
    
    
  end
  
  context "Create PurchaseDownPaymentAllocation" do
    before(:each) do
      @pdpa = PurchaseDownPaymentAllocation.create_object(
        :contact_id => @ct_1.id,
        :receivable_id => @sdp.receivable_id,
        :allocation_date => @allocation_date_1,
        :rate_to_idr => @rate_to_idr_1,
        )
    end
    
    it "should create PurchaseDownPaymentAllocation" do
      @pdpa.errors.size.should == 0
    end
    
    context "Create PurchaseDownPaymentAllocationDetail" do
      before(:each) do
        @pdpad = PurchaseDownPaymentAllocationDetail.create_object(
          :purchase_down_payment_allocation_id => @pdpa.id,
          :payable_id => @payable.id,
          :description => @description_1,
          :amount_paid => @amount_paid_1,
          :rate => @rate_1
          )
      end
      
      it "should create PurchaseDownPaymentAllocationDetail" do
        @pdpad.errors.size.should == 0
      end
      
      context "Confirm PurchaseDownPaymentAllocation" do
        before(:each) do
          @pdpa.reload
          @pdpa.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm PurchaseDownPaymentAllocation" do
          @pdpa.errors.size.should == 0
          @pdpa.is_confirmed.should == true
        end
        
        it "should create TransactionData" do
           td = TransactionData.where(
            :transaction_source_type => @pdpa.class.to_s,
            :transaction_source_id => @pdpa.id
            )
          td.count.should == 1
          td.first.is_confirmed.should == true
        end
        
        context "Unconfirm PurchaseDownPaymentAllocation" do
          before(:each) do
            @pdpa.reload
            @pdpa.unconfirm_object
          end
        end
      end
      
      
    end
  end
end
