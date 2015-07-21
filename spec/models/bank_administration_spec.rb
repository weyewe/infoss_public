require 'spec_helper'

describe BankAdministration do
  before(:each) do
    @exc_1 = Exchange.create_object(
      :name => "@name_1",
      :description => "@description_1",
    )
    
    @exr_1 = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => DateTime.now,
      :rate => BigDecimal("5000")
    )
    
    
    @cb1 = CashBank.create_object(
      :name => "source name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true ,
      :exchange_id => @exc_1.id
    )
    
    @cb2 = CashBank.create_object(
      :name => "target name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true ,
      :exchange_id => @exc_1.id
    )
    
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )
      
    @administration_date_1 = DateTime.now
    @administration_date_2 = DateTime.now + 1.days
    @description_1 = "description_1"
    @description_2 = "description_2"
    @no_bukti_1 = "no_bukti_1"
    @no_bukti_2 = "no_bukti_2"
  end
  
  context "Create BankAdministration" do
    before(:each) do
      @ba = BankAdministration.create_object(
        :cash_bank_id => @cb1.id,
        :administration_date => @administration_date_1,
        :description => @description_1,
        :no_bukti => @no_bukti_1
        )
    end
    
    it "should create BankAdministration" do
      @ba.errors.size.should == 0
    end
    
    context "Create BankAdministrationDetail" do
      before(:each) do
        @bad = BankAdministrationDetail.create_object(
          :bank_administration_id => @ba.id,
          :account_id => @coa_1.id,
          :description => "description_1",
          :status => NORMAL_BALANCE[:debet],
          :amount => BigDecimal("1000")
          )
      end
      
      it "should create BankAdministrationDetail" do
        @bad.errors.size.should == 0
        
      end
      
      context "Confirm BankAdministration" do
        before(:each) do
          @ba.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm BankAdministration" do
          @ba.errors.size.should == 0
          @ba.is_confirmed.should == true
        end
        
        context "Unconfirm BankAdministration" do
          before(:each) do
            @ba.unconfirm_object
          end
          
          it "should unconfirm BankAdministration" do
            @ba.errors.size.should == 0
            @ba.is_confirmed.should == false
          end
          
        end
      end
      
    end
  end
end
