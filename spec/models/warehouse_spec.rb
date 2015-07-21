require 'spec_helper'

describe Warehouse do
  before (:each) do
    @code_1 = "code_1"
    @code_2 = "code_2"
    @name_1 = "item_type1"
    @name_2 = "item_type2"
    @description_1 = "description_1"
    @description_2 = "description_2"
  end
  
  it "should be allowed to create item_type" do
    wrh = Warehouse.create_object(
      :name => @name_1,
      :description => @description_1,
      :code => @code_1
      )
    wrh.should be_valid
    wrh.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    wrh = Warehouse.create_object(
      :name => nil,
      :description => @description_1,
      :code => @code_1
      )
    wrh.errors.size.should_not == 0 
    wrh.should_not be_valid
  end
  
  it "should not create object if name present, but length == 0 " do
    wrh = Warehouse.create_object(
      :name => "",
      :description => @description_1,
      :code => @code_1
      )
    wrh.errors.size.should_not == 0 
    wrh.should_not be_valid
  end
  
  it "should not create object without code" do
    wrh = Warehouse.create_object(
      :name => @name_1,
      :description => @description_1,
      :code => nil
      )
    wrh.errors.size.should_not == 0 
    wrh.should_not be_valid
  end
  
  it "should not create object if code present, but length == 0 " do
    wrh = Warehouse.create_object(
      :name => @name_1,
      :description => @description_1,
      :code => ""
    )
    wrh.errors.size.should_not == 0 
    wrh.should_not be_valid
  end
  
  
  context "Create New Warehouse" do
    before (:each) do
      @wrh = Warehouse.create_object(
        :name => @name_1 ,
        :description => @description_1,
        :code => @code_1
      )
    end
    
    it "should create warehouse" do
      @wrh.errors.size.should == 0
      @wrh.should be_valid
    end
    
    it "should not create warehouse with same code" do
      wrh_2 = Warehouse.create_object(
        :name => @name_1 ,
        :description => @description_1,
        :code => @code_1
        )
      wrh_2.errors.size.should_not == 0
    end
    
    it "cannot update object if name not valid" do
      @wrh.update_object(
       :name => nil,
       :description => @description_2,
       :code => @code_2
      )
      @wrh.errors.size.should_not == 0 
      @wrh.should_not be_valid
    end
    
    it "cannot update object if name present, but length == 0" do
      @wrh.update_object(
       :name => "",
       :description => @description_2,
        :code => @code_2
      )
      @wrh.errors.size.should_not == 0 
      @wrh.should_not be_valid
    end   
    
    it "cannot update object if code not valid" do
      @wrh.update_object(
       :name => @name_2,
       :description => @description_2,
       :code => nil
      )
      @wrh.errors.size.should_not == 0 
      @wrh.should_not be_valid
    end
    
    it "cannot update object if code present, but length == 0" do
      @wrh.update_object(
       :name => @name_2,
       :description => @description_2,
       :code => ""
      )
      @wrh.errors.size.should_not == 0 
      @wrh.should_not be_valid
    end  
    
    it "should update object" do
      @wrh.update_object(
        :name => @name_2 ,
        :description => @description_2,
        :code => @code_2
      )
      @wrh.name.should == @name_2
      @wrh.description.should == @description_2
      @wrh.code.should == @code_2
    end
  
    it "should delete object" do
      @wrh.delete_object
      Warehouse.count.should == 0
    end

  end
  
end

