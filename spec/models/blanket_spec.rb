require 'spec_helper'

describe Blanket do
  before(:each) do
    @cg_1 = ContactGroup.create_object(
        :name => "Group1" ,
      :description => "Description1"
      )
    @cg_2 = ContactGroup.create_object(
        :name => "Group2" ,
      :description => "Description2"
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
    
    @machine_1 = Machine.create_object(
      :code => "code_1",
      :name => "name_1",
      :description => "description_1"
      )
      
    @machine_2 = Machine.create_object(
      :code => "code_2",
      :name => "name_2",
      :description => "description_2"
      )
    
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )
    
    @itp_1 = ItemType.create_object(
      :name => "RollBlanket2" ,
      :description => "Description1",
      :account_id => @coa_1.id
      )
    
    # @itp_2 = ItemType.create_object(
    #   :name => "Adhesive" ,
    #   :description => "Description1",
    #   :account_id => @coa_1.id
    #   )
    
    # @itp_3 = ItemType.create_object(
    #   :name => "Bar" ,
    #   :description => "Description1",
    #   :account_id => @coa_1.id
    #   )
      
    @sbp_1 = SubType.create_object(
      :name => "SubType_1" ,
      :item_type_id => @itp_1.id
      )
    
    @sbp_2 = SubType.create_object(
      :name => "SubType_2" ,
      :item_type_id => @itp_1.id
      )
      
    @uom_1 = Uom.create_object(
      :name => "Uom_1" ,
      )
    
    @uom_2 = Uom.create_object(
      :name => "Uom_2" ,
      )
    
    @exc_1 = Exchange.create_object(
      :name => "IDR1",
      :description => @description_1,
      )
    
    @exc_2 = Exchange.create_object(
      :name => "USD",
      :description => @description_1,
      )
    
    @roll_blanket_1 = Item.create_object(
      :item_type_id => ItemType.find_by_name("RollBlanket").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_1",
      :name => "name_1",
      :description => "description_1",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("1000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      
      )
    @roll_blanket_2 = Item.create_object(
      :item_type_id => ItemType.find_by_name("RollBlanket").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_2",
      :name => "name_2",
      :description => "description_2",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    
    @adhesive_1 = Item.create_object(
      :item_type_id => ItemType.find_by_name("AdhesiveBlanket").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_3",
      :name => "name_3",
      :description => "description_3",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
      
    @adhesive_2 = Item.create_object(
      :item_type_id => ItemType.find_by_name("AdhesiveBlanket").id,
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
    
    @bar_1 = Item.create_object(
      :item_type_id => ItemType.find_by_name("Bar").id,
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
    
    @bar_2 = Item.create_object(
      :item_type_id => ItemType.find_by_name("Bar").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_6",
      :name => "name_6",
      :description => "description_2",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
      
    @name_1 = "Item_1"
    @name_2 = "Item_2"
    @sku_1 = "sku_112"
    @sku_2 = "sku_233"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @roll_no_1 = "roll_no_1"
    @roll_no_2 = "roll_no_2"
    @ac_1 = BigDecimal("10")
    @ac_2 = BigDecimal("20")
    @ar_1 = BigDecimal("10")
    @ar_2 = BigDecimal("20")
    @thickness_1 = BigDecimal("10")
    @thickness_2 = BigDecimal("20")
    @is_bar_required_1 = true
    @is_bar_required_2 = false
    @left_over_ac_1  =  BigDecimal("100")
    @left_over_ac_2 = BigDecimal("200")
    @left_over_ar_1 = BigDecimal("100")
    @left_over_ar_2 = BigDecimal("200")
    @special_1 = BigDecimal("1000")
    @special_2 = BigDecimal("2000")
    @cropping_type_1 = CROPPING_TYPE[:normal]
    @cropping_type_2 = CROPPING_TYPE[:special]
    @application_case_1 = APPLICATION_CASE[:sheetfed]
    @application_case_1 = APPLICATION_CASE[:web]
    
  end
  
  it "should not create object if sku is not valid" do
    blanket = Blanket.create_object(
      :sku => nil,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :roll_no => @roll_no_1,
      :contact_id => @ct_1.id,
      :machine_id => @machine_1.id,
      :adhesive_id => @adhesive_1.id,
      :adhesive2_id => @adhesive_2.id,
      :roll_blanket_item_id => @roll_blanket_1.id,
      :left_bar_item_id => @bar_1.id,
      :right_bar_item_id => @bar_2.id,
      :ac => @ac_1,
      :ar => @ar_1,
      :thickness => @thickness_1,
      :is_bar_required => @is_bar_required_1,
      :cropping_type => @cropping_type_1,
      :special => @special_1,
      :application_case => @application_case_1,
      :left_over_ac => @left_over_ac_1,
      :left_over_ar => @left_over_ar_1,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    blanket.errors.size.should_not == 0
    blanket.should_not be_valid
  end
  
  it "should not create object if name is not valid" do
    blanket = Blanket.create_object(
      :sku => @sku_1,
      :name => nil,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :roll_no => @roll_no_1,
      :contact_id => @ct_1.id,
      :machine_id => @machine_1.id,
      :adhesive_id => @adhesive_1.id,
      :adhesive2_id => @adhesive_2.id,
      :roll_blanket_item_id => @roll_blanket_1.id,
      :left_bar_item_id => @bar_1.id,
      :right_bar_item_id => @bar_2.id,
      :ac => @ac_1,
      :ar => @ar_1,
      :thickness => @thickness_1,
      :is_bar_required => @is_bar_required_1,
      :cropping_type => @cropping_type_1,
      :special => @special_1,
      :application_case => @application_case_1,
      :left_over_ac => @left_over_ac_1,
      :left_over_ar => @left_over_ar_1,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    blanket.errors.size.should_not == 0
    blanket.should_not be_valid
  end
  
  context "create Blanket" do
    before(:each) do
      @blanket = Blanket.create_object(
      :sku => @sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :roll_no => @roll_no_1,
      :contact_id => @ct_1.id,
      :machine_id => @machine_1.id,
      :adhesive_id => @adhesive_1.id,
      :adhesive2_id => @adhesive_2.id,
      :roll_blanket_item_id => @roll_blanket_1.id,
      :left_bar_item_id => @bar_1.id,
      :right_bar_item_id => @bar_2.id,
      :ac => @ac_1,
      :ar => @ar_1,
      :thickness => @thickness_1,
      :is_bar_required => @is_bar_required_1,
      :cropping_type => @cropping_type_1,
      :special => @special_1,
      :application_case => @application_case_1,
      :left_over_ac => @left_over_ac_1,
      :left_over_ar => @left_over_ar_1,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    end
    
    it "should create Blanket" do
      @blanket.errors.size.should == 0
      @blanket.should be_valid
    end
    
    it "should not update Blanket if sku is not valid" do
      @blanket.update_object(
        :sku => nil,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :roll_no => @roll_no_2,
        :contact_id => @ct_2.id,
        :machine_id => @machine_2.id,
        :adhesive_id => @adhesive_2.id,
        :adhesive2_id => @adhesive_1.id,
        :roll_blanket_item_id => @roll_blanket_2.id,
        :left_bar_item_id => @bar_2.id,
        :right_bar_item_id => @bar_1.id,
        :ac => @ac_2,
        :ar => @ar_2,
        :thickness => @thickness_2,
        :is_bar_required => @is_bar_required_2,
        :cropping_type => @cropping_type_2,
        :special => @special_2,
        :application_case => @application_case_2,
        :left_over_ac => @left_over_ac_2,
        :left_over_ar => @left_over_ar_2,
        :minimum_amount => BigDecimal("1"),
        :selling_price => BigDecimal("2000"),
        :price_list => BigDecimal("500"),
        :exchange_id => @exc_1.id,
        )
      @blanket.errors.size.should_not == 0
      @blanket.should_not be_valid
    end
    
    it "should not update Blanket if name is not valid" do
      @blanket.update_object(
      :sku => @sku_2,
      :name => nil,
      :description => @description_2,
      :uom_id => @uom_2.id,
      :roll_no => @roll_no_2,
      :contact_id => @ct_2.id,
      :machine_id => @machine_2.id,
      :adhesive_id => @adhesive_2.id,
      :adhesive2_id => @adhesive_1.id,
      :roll_blanket_item_id => @roll_blanket_2.id,
      :left_bar_item_id => @bar_2.id,
      :right_bar_item_id => @bar_1.id,
      :ac => @ac_2,
      :ar => @ar_2,
      :thickness => @thickness_2,
      :is_bar_required => @is_bar_required_2,
      :cropping_type => @cropping_type_2,
      :special => @special_2,
      :application_case => @application_case_2,
      :left_over_ac => @left_over_ac_2,
      :left_over_ar => @left_over_ar_2,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
      @blanket.errors.size.should_not == 0
      @blanket.should_not be_valid
    end  
    
    it "should update Blanket" do
      @blanket.update_object(
      :sku => @sku_2,
      :name => @name_2,
      :description => @description_2,
      :uom_id => @uom_2.id,
      :roll_no => @roll_no_2,
      :contact_id => @ct_2.id,
      :machine_id => @machine_2.id,
      :adhesive_id => @adhesive_2.id,
      :adhesive2_id => @adhesive_1.id,
      :roll_blanket_item_id => @roll_blanket_2.id,
      :left_bar_item_id => @bar_2.id,
      :right_bar_item_id => @bar_1.id,
      :ac => @ac_2,
      :ar => @ar_2,
      :thickness => @thickness_2,
      :is_bar_required => @is_bar_required_2,
      :cropping_type => @cropping_type_2,
      :special => @special_2,
      :application_case => @application_case_2,
      :left_over_ac => @left_over_ac_2,
      :left_over_ar => @left_over_ar_2,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
      
      @blanket.sku.should == @sku_2
      @blanket.name.should == @name_2
      @blanket.description.should == @description_2
      @blanket.uom_id.should == @uom_2.id
      @blanket.roll_no.should == @roll_no_2
      @blanket.contact_id.should == @ct_2.id
      @blanket.machine_id.should == @machine_2.id
      @blanket.adhesive_id.should == @adhesive_2.id
      @blanket.adhesive2_id.should == @adhesive_1.id
      @blanket.roll_blanket_item_id.should == @roll_blanket_2.id
      @blanket.left_bar_item_id.should == @bar_2.id
      @blanket.right_bar_item_id.should == @bar_1.id
      @blanket.ac.should == @ac_2
      @blanket.ar.should == @ar_2
      @blanket.thickness.should == @thickness_2
      @blanket.is_bar_required.should == @is_bar_required_2
      @blanket.cropping_type.should == @cropping_type_2
      @blanket.special.should == @special_2
      @blanket.application_case.should == @application_case_2
      @blanket.left_over_ac.should == @left_over_ac_2
      @blanket.left_over_ar.should == @left_over_ar_2
    end
    
    it "should delete Blanket" do
      @blanket.delete_object
      Blanket.count.should == 0
    end
  end
  
end
