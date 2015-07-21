require 'spec_helper'

describe RollerIdentificationForm do
    
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
    
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
   
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
      :contact_type => CONTACT_TYPE[:customer],
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
      :contact_type => CONTACT_TYPE[:customer],
      :default_payment_term => 30,
      :nama_faktur_pajak => "nama_faktur_pajak_1",
      :contact_group_id => @cg_1.id
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
      :description => @description_1,
      )
    
    @roller_type_1 = RollerType.create_object(
      :name => "name_1",
      :description => "description_1"
      )
    
    @machine_1 = Machine.create_object(
      :code => "code_1",
      :name => "name_1",
      :description => "description_1"
      )
    
    @cb_1 = CoreBuilder.create_object(
        :base_sku => "123",
        :name => "name1",
        :description => "description_1",
        :uom_id => @uom_1.id,
        :machine_id => @machine_1.id,
        :core_builder_type_case => CORE_BUILDER_TYPE[:shaft],
        :cd => BigDecimal("10"),
        :tl => BigDecimal("10")
        )
        
    @sa_1 = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => DateTime.now,
      :description => "description_1"
      )
     
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @cb_1.new_core_item.item.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    
    @sa_1.confirm_object(:confirmed_at => DateTime.now)    
    
    @is_in_house_1 = true
    @is_in_house_2 = false
    @amount_1 = 1
    @amount_2 = 2
    @identified_date_1 = DateTime.now
    @identified_date_2 = DateTime.now + 1.days
    @nomor_disasembly_1 = "nomor_disasembly_1"
    @nomor_disasembly_2 = "nomor_disasembly_2"
  end
  
  it "should not create RollerIdentificationForm if warehouse_id is not valid" do
    rif = RollerIdentificationForm.create_object(
      :warehouse_id => 123123,
      :contact_id => @ct_1.id,
      :is_in_house => @is_in_house_1,
      :amount => @amount_1,
      :identified_date => @identified_date_1,
      :nomor_disasembly => @nomor_disasembly_1
      )
    rif.errors.size.should_not == 0
    rif.should_not be_valid
  end
  
  it "should not create RollerIdentificationForm if contact_id is not valid" do
    rif = RollerIdentificationForm.create_object(
      :warehouse_id => @wrh_1.id,
      :contact_id => 123123,
      :is_in_house => @is_in_house_1,
      :amount => @amount_1,
      :identified_date => @identified_date_1,
      :nomor_disasembly => @nomor_disasembly_1
      )
    rif.errors.size.should_not == 0
    rif.should_not be_valid
  end
  
  it "should not create RollerIdentificationForm if identified_date is not valid" do
    rif = RollerIdentificationForm.create_object(
      :warehouse_id => @wrh_1.id,
      :contact_id => @ct_1.id,
      :is_in_house => @is_in_house_1,
      :amount => @amount_1,
      :identified_date => nil,
      :nomor_disasembly => @nomor_disasembly_1
      )
    rif.errors.size.should_not == 0
    rif.should_not be_valid
  end
  
  context "Create RollerIdentificationForm is_in_house == true" do
    before(:each) do
      @rif = RollerIdentificationForm.create_object(
        :warehouse_id => @wrh_1.id,
        :contact_id => @ct_1.id,
        :is_in_house => @is_in_house_1,
        :amount => @amount_1,
        :identified_date => @identified_date_1,
        :nomor_disasembly => @nomor_disasembly_1
        )
    end
    
    it "should create RollerIdentificationForm" do
      @rif.errors.size.should == 0
      @rif.should be_valid
    end
    
    it "should update RollerIdentificationForm" do
      @rif.update_object(
        :warehouse_id => @wrh_2.id,
        :contact_id => @ct_2.id,
        :is_in_house => @is_in_house_2,
        :amount => @amount_2,
        :identified_date => @identified_date_2,
        :nomor_disasembly => @nomor_disasembly_2
        )
      @rif.errors.size.should == 0 
      @rif.warehouse_id.should == @wrh_2.id 
      @rif.contact_id.should == @ct_2.id 
      @rif.is_in_house.should == @is_in_house_2 
      @rif.amount.should == @amount_2 
      @rif.identified_date.should == @identified_date_2
      @rif.nomor_disasembly.should == @nomor_disasembly_2
    end
    
    it "should not update RollerIdentificationForm  if warehouse_id is not valid" do
      @rif.update_object(
        :warehouse_id => 123123,
        :contact_id => @ct_2.id,
        :is_in_house => @is_in_house_2,
        :amount => @amount_2,
        :identified_date => @identified_date_2,
        :nomor_disasembly => @nomor_disasembly_2
        )
      @rif.errors.size.should_not == 0
      @rif.should_not be_valid
    end
    
    it "should not update RollerIdentificationForm  if contact_id is not valid" do
      @rif.update_object(
        :warehouse_id => @wrh_2.id,
        :contact_id => 12323,
        :is_in_house => @is_in_house_2,
        :amount => @amount_2,
        :identified_date => @identified_date_2,
        :nomor_disasembly => @nomor_disasembly_2
        )
      @rif.errors.size.should_not == 0
      @rif.should_not be_valid
    end
    
    it "should not update RollerIdentificationForm  if identified_date is not valid" do
      @rif.update_object(
        :warehouse_id => @wrh_2.id,
        :contact_id => @ct_2.id,
        :is_in_house => @is_in_house_2,
        :amount => @amount_2,
        :identified_date => nil,
        :nomor_disasembly => @nomor_disasembly_2
        )
      @rif.errors.size.should_not == 0
      @rif.should_not be_valid
    end
    
    context "Create RollerIdentificationFormDetail" do
      before(:each) do
        @rifd = RollerIdentificationFormDetail.create_object(
          :roller_identification_form_id => @rif.id,
          :detail_id => 1,
          :material_case => MATERIAL_CASE[:new],
          :core_builder_id => @cb_1.id,
          :roller_type_id => @roller_type_1.id,
          :machine_id => @machine_1.id,
          :repair_request_case => REPAIR_REQUEST_CASE[:all],
          :roller_no => "123",
          :rd => BigDecimal("10"),
          :cd => BigDecimal("10"),
          :rl => BigDecimal("10"),
          :wl => BigDecimal("10"),
          :tl => BigDecimal("10"),
          :gl => BigDecimal("10"),
          :groove_amount => BigDecimal("10"),
          :groove_length => BigDecimal("10"),
          )
      end
      
      it "should create RollerIdentificationFormDetail" do
        @rifd.errors.size.should == 0
        @rifd.should be_valid
      end
      
      context "Confirm RollerIdentificationForm" do
        before(:each) do
          @rif.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm RollerIdentificationForm" do
          puts @rif.errors.messages
          @rif.errors.size.should == 0
          @rif.is_confirmed == true
        end
        
        context "Unconfirm RollerIdentificationForm" do
          before(:each) do
            @rif.unconfirm_object
          end
          
          it "should unconfirm RollerIdentificationForm" do
            @rif.errors.size.should == 0
            @rif.is_confirmed == false
          end
          
        end
      
      end
      
    end
    
  end
  
  context "Create RollerIdentificationForm is in house == false" do
    before(:each) do
       @rif = RollerIdentificationForm.create_object(
        :warehouse_id => @wrh_1.id,
        :contact_id => @ct_1.id,
        :is_in_house => @is_in_house_2,
        :amount => @amount_1,
        :identified_date => @identified_date_1,
        :nomor_disasembly => @nomor_disasembly_1
        )
    end
    
    it "should create RollerIdentificationForm" do
      @rif.errors.size.should == 0
      @rif.should be_valid
    end
    
    context "Create RollerIdentificationFormDetail" do
      before(:each) do
        @rifd = RollerIdentificationFormDetail.create_object(
          :roller_identification_form_id => @rif.id,
          :detail_id => 1,
          :material_case => MATERIAL_CASE[:new],
          :core_builder_id => @cb_1.id,
          :roller_type_id => @roller_type_1.id,
          :machine_id => @machine_1.id,
          :repair_request_case => REPAIR_REQUEST_CASE[:all],
          :roller_no => "123",
          :rd => BigDecimal("10"),
          :cd => BigDecimal("10"),
          :rl => BigDecimal("10"),
          :wl => BigDecimal("10"),
          :tl => BigDecimal("10"),
          :gl => BigDecimal("10"),
          :groove_amount => BigDecimal("10"),
          :groove_length => BigDecimal("10"),
          )
      end
      
      it "should create RollerIdentificationFormDetail" do
        @rifd.errors.size.should == 0
        @rifd.should be_valid
      end
      
      context "Confirm RollerIdentificationForm" do
        before(:each) do
          @rif.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm RollerIdentificationForm" do
          @rif.errors.size.should == 0
          @rif.is_confirmed == true
          Item.where(:id => @cb_1.new_core_item.item.id).first.customer_amount.should == 1
        end
        
        context "Unconfirm RollerIdentificationForm" do
          before(:each) do
            @rif.unconfirm_object
          end
          
          it "should unconfirm RollerIdentificationForm" do
            @rif.errors.size.should == 0
            @rif.is_confirmed == false
          end
          
        end
      
      end
      
    end
    
  end
  
end
