require 'spec_helper'

describe CoreBuilder do
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
    
    @base_sku_1 = "sku_1"
    @base_sku_2 = "sku_2"
    @name_1 = "name_1"
    @name_2 = "name_2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @core_builder_type_case_1 = CORE_BUILDER_TYPE[:shaft]
    @core_builder_type_case_2 = CORE_BUILDER_TYPE[:hollow]
    @cd_1 =  BigDecimal("10")
    @cd_2 =  BigDecimal("20")
    @tl_1 =  BigDecimal("10")
    @tl_2 =  BigDecimal("20")
  end
  
  it "should not create CoreBuilder if base_sku is not valid" do
   cb = CoreBuilder.create_object(
        :base_sku => nil,
        :name => @name_1,
        :description => @description_1,
        :uom_id => @uom_1.id,
        :machine_id => @machine_1.id,
        :core_builder_type_case => @core_builder_type_case_1,
        :cd => @cd_1,
        :tl => @tl_1
        )
    cb.errors.size.should_not == 0
    cb.should_not be_valid
  end
  
  it "should not create CoreBuilder if uom_id is not valid" do
   cb = CoreBuilder.create_object(
        :base_sku => @base_sku_1,
        :name => @name_1,
        :description => @description_1,
        :uom_id => 44444,
        :machine_id => @machine_1.id,
        :core_builder_type_case => @core_builder_type_case_1,
        :cd => @cd_1,
        :tl => @tl_1
        )
    cb.errors.size.should_not == 0
    cb.should_not be_valid
  end
  
  it "should not create CoreBuilder if machine_id is not valid" do
   cb = CoreBuilder.create_object(
        :base_sku => @base_sku_1,
        :name => @name_1,
        :description => @description_1,
        :uom_id => @uom_1.id,
        :machine_id => 1232131,
        :core_builder_type_case => @core_builder_type_case_1,
        :cd => @cd_1,
        :tl => @tl_1
        )
    cb.errors.size.should_not == 0
    cb.should_not be_valid
  end
  
  it "should not create CoreBuilder if core_builder_type_case is not valid" do
   cb = CoreBuilder.create_object(
        :base_sku => @base_sku_1,
        :name => @name_1,
        :description => @description_1,
        :uom_id => @uom_1.id,
        :machine_id => @machine_1.id,
        :core_builder_type_case => 5,
        :cd => @cd_1,
        :tl => @tl_1
        )
    cb.errors.size.should_not == 0
    cb.should_not be_valid
  end
  
  context "create CoreBuilder" do
    before(:each) do
      @cb = CoreBuilder.create_object(
        :base_sku => @base_sku_1,
        :name => @name_1,
        :description => @description_1,
        :uom_id => @uom_1.id,
        :machine_id => @machine_1.id,
        :core_builder_type_case => @core_builder_type_case_1,
        :cd => @cd_1,
        :tl => @tl_1
        )
    end
    
    it "should create CoreBuilder" do
      @cb.errors.size.should == 0
      @cb.should be_valid
    end
    
    it "should create 2 Core" do
      Core.count.should == 2
    end
    
    it "should not update CoreBuilder if base_sku is not valid" do
      @cb.update_object(
        :base_sku => nil,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :machine_id => @machine_2.id,
        :core_builder_type_case => @core_builder_type_case_2,
        :cd => @cd_2,
        :tl => @tl_2
        )
      @cb.errors.size.should_not == 0
      @cb.should_not be_valid
    end
    
    it "should not update CoreBuilder if uom_id is not valid" do
      @cb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => 42131,
        :machine_id => @machine_2.id,
        :core_builder_type_case => @core_builder_type_case_2,
        :cd => @cd_2,
        :tl => @tl_2
        )
      @cb.errors.size.should_not == 0
      @cb.should_not be_valid
    end
    
    it "should not update CoreBuilder if machine_id is not valid" do
      @cb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :machine_id => 12312,
        :core_builder_type_case => @core_builder_type_case_2,
        :cd => @cd_2,
        :tl => @tl_2
        )
      @cb.errors.size.should_not == 0
      @cb.should_not be_valid
    end
    
    it "should not update CoreBuilder if core_builder_type_case is not valid" do
      @cb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :machine_id => @machine_2.id,
        :core_builder_type_case => 5,
        :cd => @cd_2,
        :tl => @tl_2
        )
      @cb.errors.size.should_not == 0
      @cb.should_not be_valid
    end
    
    it "should update CoreBuilder" do
      @cb.update_object(
        :base_sku => @base_sku_2,
        :name => @name_2,
        :description => @description_2,
        :uom_id => @uom_2.id,
        :machine_id => @machine_2.id,
        :core_builder_type_case => @core_builder_type_case_2,
        :cd => @cd_2,
        :tl => @tl_2
        )
      @cb.errors.size.should == 0
      @cb.should be_valid
      @cb.base_sku.should == @base_sku_2
      @cb.name.should == @name_2
      @cb.description.should == @description_2
      @cb.uom_id.should == @uom_2.id
      @cb.machine_id.should == @machine_2.id
      @cb.core_builder_type_case.should == @core_builder_type_case_2
      @cb.cd.should == @cd_2
      @cb.tl.should == @tl_2
    end
    
    it "should delete CoreBuilder" do
      @cb.delete_object
      @cb.errors.size.should == 0
      CoreBuilder.count.should == 0
      Core.count.should == 0
    end
    
  end
  
end
