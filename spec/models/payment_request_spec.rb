require 'spec_helper'

describe PaymentRequest do
  
  before (:each) do      
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
    :code => "1110101",
    :name => "KAS",
    :account_case => ACCOUNT_CASE[:ledger],
    :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
    )

  @coa_2 = Account.create_object(
    :code => "111220101",
    :name => "BANK",
    :account_case => ACCOUNT_CASE[:ledger],
    :parent_id => Account.find_by_code(ACCOUNT_CODE[:beban_usaha][:code]).id
    )
    
  @exc_1 = Exchange.create_object(
    :name => "IDR1",
    :description => "description_1",
    )
    
  @exr_1 = ExchangeRate.create_object(
    :exchange_id => @exc_1.id,
    :ex_rate_date => DateTime.now,
    :rate => BigDecimal("1")
    )
    @request_date_1 = DateTime.now
    @request_date_2 = DateTime.now + 1.days
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days   
  end
  
  it "cannot create payment_request if contact not valid" do
    pr = PaymentRequest.create_object(
      :contact_id => 123213,
      :request_date => @request_date_1,
      :due_date => @due_date_1,
      :account_id => @coa_1.id
    )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  
  it "cannot create payment_request if requestdate not valid" do
    pr = PaymentRequest.create_object(
      :contact_id => @ct_1.id,
      :request_date => nil,
      :due_date => @due_date_1,
      :account_id => @coa_1.id
    )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  

  
  it "cannot create payment_request if due_date not valid" do
    pr = PaymentRequest.create_object(
      :contact_id => @ct_1.id,
      :request_date => @request_date_1,
      :due_date => nil,
      :account_id => @coa_1.id
    )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  
  it "cannot create payment_request if coa not valid" do
    pr = PaymentRequest.create_object(
      :contact_id => @ct_1.id,
      :request_date => @request_date_1,
      :due_date => @due_date_1,
      :account_id => 12321312
    )
    pr.errors.size.should_not == 0
    pr.should_not be_valid
  end
  
  context "Created payment request" do
    before (:each) do
      @pr = PaymentRequest.create_object(
        :contact_id => @ct_1.id,
        :request_date => @request_date_1,
        :due_date => @due_date_1,
        :account_id => @coa_1.id
        )
    end
    
    it "should create payment request" do
      @pr.errors.size.should == 0
      @pr.should be_valid
    end
    
    it "should update payment request" do
      @pr.update_object(
        :contact_id => @ct_2.id,
        :request_date => @request_date_2,
        :due_date => @due_date_2,
        :account_id => @coa_2.id
        )
      @pr.should be_valid
      @pr.errors.size.should == 0
    
      @pr.contact_id.should == @ct_2.id
      @pr.request_date.should == @request_date_2
      @pr.account_id.should == @coa_2.id
    end
    
    it "cannot update payment_request if contact not valid" do
      @pr.update_object(
        :contact_id => 123123,
        :request_date => @request_date_2,
        :due_date => @due_date_2,
        :exchange_id => @exc_1.id,
        :account_id => @coa_2.id
        )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
  
    it "cannot update payment_request if requestdate not valid" do
      @pr.update_object(
        :contact_id => @ct_2.id,
        :request_date => nil,
        :due_date => @due_date_2,
        :account_id => @coa_2.id
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
     
    it "cannot update payment_request if due_date not valid" do
      @pr.update_object(
        :contact_id => @ct_2.id,
        :request_date => @request_date_2,
        :due_date => nil,
        :account_id => @coa_2.id
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
  
    it "cannot update payment_request if coa not valid" do
      @pr.update_object(
        :contact_id => @ct_2.id,
        :request_date => @request_date_2,
        :due_date => @due_date_2,
        :account_id => 1231
      )
      @pr.errors.size.should_not == 0
      @pr.should_not be_valid
    end
    
    context "Create PaymentRequestDetail" do
      before(:each) do
        @prd = PaymentRequestDetail.create_object(
          :payment_request_id => @pr.id,
          :account_id => @coa_1.id,
          :status => STATUS_ACCOUNT[:debet],
          :amount => BigDecimal("100000"),
          )
        @pr.reload
      end
      
      it "should create PaymentRequestDetail" do       
        @prd.errors.size.should == 0
        @prd.should be_valid
      end
      
      it "should not update PaymentRquest if have details" do
        @pr.update_object(
          :contact_id => @ct_2.id,
          :request_date => @request_date_2,
          :due_date => @due_date_2,
          :account_id => @coa_2.id
        )
        @pr.errors.size.should_not == 0
      end
      
      it "should not delete PaymentRequest if have details" do
        @pr.delete_object
        @pr.errors.size.should_not == 0
      end
      
      context "Confirmed PaymentRequest" do
        before(:each) do
         @pr.confirm_object(:confirmed_at => DateTime.now)
        end

        it "should confirm PaymentRequest" do
          
          @pr.errors.size.should == 0
          @pr.is_confirmed.should be_true
        end

        it "cannot update payment_request if already confirmed" do
          @pr.update_object(
            :contact_id => @ct_2.id,
            :request_date => @request_date_2,
            :due_date => @due_date_2,
            :account_id => @coa_2.id
          )
          @pr.errors.size.should_not == 0
        end

        it "cannot confirm if already confirmed" do
          @pr.confirm_object(:confirmed_at => DateTime.now)
          @pr.errors.size.should_not == 0

        end

        it "should create  1 payable" do
          payable_count = Payable.where(
            :source_id => @pr.id,
            :source_class => @pr.class.to_s,
            ).count
          payable_count.should == 1
        end
        
        it "should create 1 TransactionalData" do
         td = TransactionData.where(
            :transaction_source_type => @pr.class.to_s,
            :transaction_source_id => @pr.id
            )
          td.count.should == 1
        end
        
        context "Unconfirm payment request" do
          before(:each) do
            @pr.unconfirm_object
          end

          it "should unconfirm payment_request" do
            @pr.errors.size.should == 0
            @pr.is_confirmed.should be_false
            @pr.confirmed_at == nil
          end

          it "cannot unconfirm if not confirmed" do
            @pr.unconfirm_object
            @pr.errors.size.should_not == 0
          end

          it "should delete 1 payable" do
            payable_count = Payable.where(
                  :source_id => @pr.id,
                  :source_class => @pr.class.to_s,
            ).count
            payable_count.should == 0
          end
        end
      end
    end
  end
end
