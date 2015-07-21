require 'spec_helper'

describe RollerBuilder do
  before(:each) do
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
      
    @sbp_1 = SubType.create_object(
      :name => "SubType_1" ,
      :item_type_id => @itp_1.id
      )
    
    @sbp_2 = SubType.create_object(
      :name => "SubType_2" ,
      :item_type_id => @itp_1.id
      )
    
    @adhesive_1 = Item.create_object(
      :item_type_id => ItemType.find_by_name("AdhesiveRoller").id,
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
      :item_type_id => ItemType.find_by_name("AdhesiveRoller").id,
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
    
    @compound_1 = Item.create_object(
      :item_type_id => ItemType.find_by_name("Compound").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_5",
      :name => "name_3",
      :description => "description_3",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
      
    @compound_2 = Item.create_object(
      :item_type_id => ItemType.find_by_name("Compound").id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_6",
      :name => "name_4",
      :description => "description_2",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )  
    
    @roller_type_1 = RollerType.create_object(
      :name => "name_1",
      :description => "description_1"
      )
    
    @roller_type_2 = RollerType.create_object(
      :name => "name_2",
      :description => "description_2"
      )
    
    @core_builder_1 = CoreBuilder.create_object(
      :base_sku => "cb_base1",
      :name => "name1",
      :description => "description_2",
      :uom_id => @uom_1.id,
      :machine_id => @machine_1.id,
      :core_builder_type_case => CORE_BUILDER_TYPE[:shaft],
      :cd => BigDecimal("10"),
      :tl => BigDecimal("10")
      )
    
    @core_builder_2 = CoreBuilder.create_object(
      :base_sku => "cb_base2",
      :name => "name2",
      :description => "description_2",
      :uom_id => @uom_1.id,
      :machine_id => @machine_1.id,
      :core_builder_type_case => CORE_BUILDER_TYPE[:hollow],
      :cd => BigDecimal("10"),
      :tl => BigDecimal("10")
      )
      
    @base_sku_1 = "sku_1"
    @base_sku_2 = "sku_2"
    @name_1 = "name_1"
    @name_2 = "name_2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @is_grooving_1 = true
    @is_grooving_2 = false
    @is_crowning_1 = true
    @is_crowning_2 = false
    @is_chamfer_1 = true
    @is_chamfer_2 = false
    @crowning_size_1 = BigDecimal("10")
    @crowning_size_2 = BigDecimal("20")
    @grooving_width_1 = BigDecimal("10")
    @grooving_width_2 = BigDecimal("20")
    @grooving_depth_1 = BigDecimal("10")
    @grooving_depth_2 = BigDecimal("20")
    @grooving_position_1 = BigDecimal("10")
    @grooving_position_2 = BigDecimal("20")
    @cd_1 =  BigDecimal("10")
    @cd_2 =  BigDecimal("20")
    @rd_1 =  BigDecimal("10")
    @rd_2 =  BigDecimal("20")
    @rl_1 =  BigDecimal("10")
    @rl_2 =  BigDecimal("20")
    @wl_1 =  BigDecimal("10")
    @wl_2 =  BigDecimal("20")
    @tl_1 =  BigDecimal("10")
    @tl_2 =  BigDecimal("20")
  end
  
  it "should not create RollerBuilder if base_sku is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => nil,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :adhesive_id => @adhesive_1.id,
      :compound_id => @compound_1.id,
      :machine_id => @machine_1.id,
      :roller_type_id => @roller_type_1.id,
      :core_builder_id => @core_builder_1.id,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  it "should not create RollerBuilder if uom_id is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => @base_sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => 12312,
      :adhesive_id => @adhesive_1.id,
      :compound_id => @compound_1.id,
      :machine_id => @machine_1.id,
      :roller_type_id => @roller_type_1.id,
      :core_builder_id => @core_builder_1.id,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  it "should not create RollerBuilder if adhesive_id is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => @base_sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :adhesive_id => 123213,
      :compound_id => @compound_1.id,
      :machine_id => @machine_1.id,
      :roller_type_id => @roller_type_1.id,
      :core_builder_id => @core_builder_1.id,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  it "should not create RollerBuilder if compound_id is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => @base_sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :adhesive_id => @adhesive_1.id,
      :compound_id => 1231231,
      :machine_id => @machine_1.id,
      :roller_type_id => @roller_type_1.id,
      :core_builder_id => @core_builder_1.id,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  it "should not create RollerBuilder if machine_id is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => @base_sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :adhesive_id => @adhesive_1.id,
      :compound_id => @compound_1.id,
      :machine_id => 123213,
      :roller_type_id => @roller_type_1.id,
      :core_builder_id => @core_builder_1.id,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  it "should not create RollerBuilder if roller_type_id is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => @base_sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :adhesive_id => @adhesive_1.id,
      :compound_id => @compound_1.id,
      :machine_id => @machine_1.id,
      :roller_type_id => 123123,
      :core_builder_id => @core_builder_1.id,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  it "should not create RollerBuilder if core_builder_id is not valid" do
    rb = RollerBuilder.create_object(
      :base_sku => @base_sku_1,
      :name => @name_1,
      :description => @description_1,
      :uom_id => @uom_1.id,
      :adhesive_id => @adhesive_1.id,
      :compound_id => @compound_1.id,
      :machine_id => @machine_1.id,
      :roller_type_id => @roller_type_1.id,
      :core_builder_id => 123213,
      :is_grooving => @is_grooving_1,
      :is_crowning => @is_crowning_1,
      :is_chamfer => @is_chamfer_1,
      :crowning_size => @crowning_size_1,
      :grooving_width => @grooving_width_1,
      :grooving_depth => @grooving_depth_1,
      :grooving_position => @grooving_position_1,
      :cd => @cd_1,
      :rd => @rd_1,
      :rl => @rl_1,
      :wl => @wl_1,
      :tl => @tl_1
      )
    rb.errors.size.should_not == 0
    rb.should_not be_valid
  end
  
  context "create RollerBuilder" do
    before(:each) do
      @rb = RollerBuilder.create_object(
        :base_sku => @base_sku_1,
        :name => @name_1,
        :description => @description_1,
        :uom_id => @uom_1.id,
        :adhesive_id => @adhesive_1.id,
        :compound_id => @compound_1.id,
        :machine_id => @machine_1.id,
        :roller_type_id => @roller_type_1.id,
        :core_builder_id => @core_builder_1.id,
        :is_grooving => @is_grooving_1,
        :is_crowning => @is_crowning_1,
        :is_chamfer => @is_chamfer_1,
        :crowning_size => @crowning_size_1,
        :grooving_width => @grooving_width_1,
        :grooving_depth => @grooving_depth_1,
        :grooving_position => @grooving_position_1,
        :cd => @cd_1,
        :rd => @rd_1,
        :rl => @rl_1,
        :wl => @wl_1,
        :tl => @tl_1
        )
    end
    
    it "should create RollerBuilder" do
      @rb.errors.size.should == 0
      @rb.should be_valid
    end
    
    it "should create 2 Roller" do
      Roller.count.should == 2
    end
    
    it "should not update RollerBuilder if base_sku is not valid" do
      @rb.update_object(
        :base_sku => nil,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => @adhesive_2.id,
        :compound_id => @compound_2.id,
        :machine_id => @machine_2.id,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
     it "should not update RollerBuilder if uom_id is not valid" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => 123213,
        :adhesive_id => @adhesive_2.id,
        :compound_id => @compound_2.id,
        :machine_id => @machine_2.id,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
     it "should not update RollerBuilder if adhesive_id is not valid" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => 123123,
        :compound_id => @compound_2.id,
        :machine_id => @machine_2.id,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
     it "should not update RollerBuilder if compound_id is not valid" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => @adhesive_2.id,
        :compound_id => 123213,
        :machine_id => @machine_2.id,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
     it "should not update RollerBuilder if machine_id is not valid" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => @adhesive_2.id,
        :compound_id => @compound_2.id,
        :machine_id => 123123,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
     it "should not update RollerBuilder if roller_type_id is not valid" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => @adhesive_2.id,
        :compound_id => @compound_2.id,
        :machine_id => @machine_2.id,
        :roller_type_id => 123213,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
     it "should not update RollerBuilder if core_builder_id is not valid" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => @adhesive_2.id,
        :compound_id => @compound_2.id,
        :machine_id => @machine_2.id,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => 123213,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should_not == 0
      @rb.should_not be_valid
    end
    
    it "should update RollerBuilder" do
      @rb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :adhesive_id => @adhesive_2.id,
        :compound_id => @compound_2.id,
        :machine_id => @machine_2.id,
        :roller_type_id => @roller_type_2.id,
        :core_builder_id => @core_builder_2.id,
        :is_grooving => @is_grooving_2,
        :is_crowning => @is_crowning_2,
        :is_chamfer => @is_chamfer_2,
        :crowning_size => @crowning_size_2,
        :grooving_width => @grooving_width_2,
        :grooving_depth => @grooving_depth_2,
        :grooving_position => @grooving_position_2,
        :cd => @cd_2,
        :rd => @rd_2,
        :rl => @rl_2,
        :wl => @wl_2,
        :tl => @tl_2
        )
      @rb.errors.size.should == 0
      @rb.base_sku.should == @base_sku_2
      @rb.name.should == @name_2
      @rb.description.should == @description_2
      @rb.uom_id.should == @uom_2.id
      @rb.adhesive_id.should == @adhesive_2.id
      @rb.compound_id.should == @compound_2.id
      @rb.machine_id.should == @machine_2.id
      @rb.roller_type_id.should == @roller_type_2.id
      @rb.core_builder_id.should == @core_builder_2.id
      @rb.is_grooving.should == @is_grooving_2
      @rb.is_crowning.should == @is_crowning_2
      @rb.is_chamfer.should == @is_chamfer_2
      @rb.crowning_size.should == @crowning_size_2
      @rb.grooving_width.should == @grooving_width_2
      @rb.grooving_depth.should == @grooving_depth_2
      @rb.grooving_position.should == @grooving_position_2
      @rb.cd.should == @cd_2
      @rb.rd.should == @rd_2
      @rb.rl.should == @rl_2
      @rb.wl.should == @wl_2
      @rb.tl.should == @tl_2
    end
    
    it "should delete RollerBuilder" do
      @rb.delete_object
      @rb.errors.size.should == 0
      Roller.count.should == 0
    end
  
  end
end
