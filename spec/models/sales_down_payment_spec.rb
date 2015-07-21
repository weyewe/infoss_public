require 'spec_helper'

describe SalesDownPayment do
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
      
    @down_payment_date_1 = DateTime.now
    @down_payment_date_2 = DateTime.now + 1.days
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @total_amount_1 = BigDecimal("10000")
    @total_amount_2 = BigDecimal("20000")
  end
  
  context "create SalesDownPayment" do
    before(:each) do
      @sdp = SalesDownPayment.create_object(
        :contact_id => @ct_1.id,
        :exchange_id => @exc_1.id,
        :down_payment_date => @down_payment_date_1,
        :due_date => @due_date_1,
        :total_amount => @total_amount_1 
        )
    end
    
    it "should create SalesDownPayment" do
      @sdp.errors.size.should == 0
      @sdp.should be_valid
    end
    
    context "confirm SalesDownPayment" do
      before(:each) do
        @sdp.confirm_object(:confirmed_at => DateTime.now)
      end
      
      it "should confirm SalesDownPayment" do
        @sdp.errors.size.should == 0
        @sdp.is_confirmed.should == true
      end
      
      it "should create Payable and Receivable" do
        @sdp.payable_id.should_not nil
        @sdp.receivable_id.should_not nil
      end
      
      it "should create TransactionData" do
        TransactionData.count.should == 1
        TransactionData.first.is_confirmed == true
      end
      
      context "unconfirm SalesDownPayment" do
        before(:each) do
          @sdp.unconfirm_object
        end
        
        it "should unconfirm SalesDownPayment" do
          @sdp.errors.size.should == 0
          @sdp.is_confirmed.should == false
        end
      end
    end
  end
end
