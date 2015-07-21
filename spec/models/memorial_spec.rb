require 'spec_helper'

describe Memorial do
  before(:each) do
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )
    
    @coa_2 = Account.create_object(
      :code => "1110k3o",
      :name => "KAS3",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )
    @description_1 = "description_1"
    @description_2 = "description_2"
    @no_bukti_1 = "no_bukti_1"
    @no_bukti_2 = "no_bukti_2"
    @amount_1 = BigDecimal("1000")
    @amount_2 = BigDecimal("1500")
  end
  
  context "Create Memorial" do
    before(:each) do
      @memo = Memorial.create_object(
        :description => @description_1,
        :no_bukti => @no_bukti_1,
        :amount => @amount_1
        )
    end
    
    it "should create Memorial" do
      @memo.errors.size.should == 0
    end
    
    context "Create MemorialDetail" do
      before(:each) do
        @memod_1 = MemorialDetail.create_object(
          :memorial_id => @memo.id,
          :account_id => @coa_1.id,
          :amount => BigDecimal("1000"),
          :status => NORMAL_BALANCE[:debet]
          )
        @memod_2 = MemorialDetail.create_object(
          :memorial_id => @memo.id,
          :account_id => @coa_2.id,
          :amount => BigDecimal("1000"),
          :status => NORMAL_BALANCE[:credit]
          )
      end
      
      it "should create MemorialDetail" do
        @memod_1.errors.size.should == 0
      end
      
      context "Confirm Memorial" do
        before(:each) do
          @memo.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm Memorial" do
          puts @memo.errors.messages
          @memo.errors.size.should == 0
          @memo.is_confirmed.should == true
        end
        
        context "Unconfirm Memorial" do
          before(:each) do
            @memo.unconfirm_object
          end
          
          it "should unconfirm Memorial" do
            @memo.errors.size.should == 0
            @memo.is_confirmed.should == false
          end
          
        end
      end
      
    end
  end
end
