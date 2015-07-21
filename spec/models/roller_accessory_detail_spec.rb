require 'spec_helper'

describe RollerAccessoryDetail do
  before(:each)do
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
  
    @accesory_1 = Item.create_object(
      :item_type_id => ItemType.find_by_name("Accessory").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_4",
      :name => "name_4",
      :description => "description_2",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    
    @accesory_2 = Item.create_object(
      :item_type_id => ItemType.find_by_name("Accessory").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_5",
      :name => "name_5",
      :description => "description_2",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
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
    @rif = RollerIdentificationForm.create_object(
      :warehouse_id => @wrh_1.id,
      :contact_id => @ct_1.id,
      :is_in_house => @is_in_house_1,
      :amount => 1,
      :identified_date => DateTime.now,
      :nomor_disasembly => "nomor_disasembly_1"
      )
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
    @rif.confirm_object(:confirmed_at => DateTime.now)
    @amount_1 = 1
    @amount_2 = 2
  end
  
  it "should not create RollerAccessoryDetail if roller_identification_form_detail_id is not valid" do
    rad = RollerAccessoryDetail.create_object(
      :roller_identification_form_detail_id => 123213,
      :item_id => @accesory_1.id,
      :amount => @amount_1
      )
    rad.errors.size.should_not == 0
    rad.should_not be_valid
  end
  
  it "should not create RollerAccessoryDetail if item_id is not valid" do
    rad = RollerAccessoryDetail.create_object(
      :roller_identification_form_detail_id => @rifd.id,
      :item_id => 1231231,
      :amount => @amount_1
      )
    rad.errors.size.should_not == 0
    rad.should_not be_valid
  end
  
  it "should not create RollerAccessoryDetail if amount is not valid" do
    rad = RollerAccessoryDetail.create_object(
      :roller_identification_form_detail_id => @rifd.id,
      :item_id => @accesory_1.id,
      :amount => 0
      )
    rad.errors.size.should_not == 0
    rad.should_not be_valid
  end
  
  
  context "Create RollerAccessoryDetail" do
    before(:each)do
      @rad = RollerAccessoryDetail.create_object(
        :roller_identification_form_detail_id => @rifd.id,
        :item_id => @accesory_1.id,
        :amount => @amount_1
        )
    end
    
    it "should create RollerAccessoryDetail" do
      @rad.errors.size.should == 0 
      @rad.should be_valid
    end
    
    it "should not update RollerAccessoryDetail if roller_identification_form_detail_id is not valid" do
      @rad.update_object(
        :roller_identification_form_detail_id => 123123,
        :item_id => @accesory_2.id,
        :amount => @amount_2
        )
      @rad.errors.size.should_not == 0
      @rad.should_not be_valid
    end
    
    it "should not update RollerAccessoryDetail if item_id is not valid" do
      @rad.update_object(
        :roller_identification_form_detail_id => @rifd.id,
        :item_id => 123213,
        :amount => @amount_2
        )
      @rad.errors.size.should_not == 0
      @rad.should_not be_valid
    end
    
    it "should not update RollerAccessoryDetail if amount is not valid" do
      @rad.update_object(
        :roller_identification_form_detail_id => @rifd.id,
        :item_id => @accesory_2.id,
        :amount => 0
        )
      @rad.errors.size.should_not == 0
      @rad.should_not be_valid
    end
    
    it "should update RollerAccessoryDetail" do
      @rad.update_object(
        :roller_identification_form_detail_id => @rifd.id,
        :item_id => @accesory_2.id,
        :amount => @amount_2
        )
      @rad.errors.size.should == 0 
      @rad.should be_valid
      @rad.roller_identification_form_detail_id.should == @rifd.id
      @rad.item_id.should == @accesory_2.id
      @rad.amount.should == @amount_2
    end
    
    it "should delete RollerAccessoryDetail" do
      @rad.delete_object
      @rad.errors.size.should == 0
      RollerAccessoryDetail.count.should == 0
    end
  end
  
  
end
