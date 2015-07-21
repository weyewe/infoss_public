require 'spec_helper'

describe Employee do
   
  before (:each) do
    @name_1 = "Employee1"
    @name_2 = "Employee2"
    @description_1 = "description1"
    @description_2 = "description2"
    @contact_no_1 = "123412"
    @contact_no_2 = "231234"
    @address_1 = "address1"
    @address_2 = "addess2"
    @email_1 = "email1@email.com"
    @email_2 = "email2@email.com"
   
  end
  
  it "should be allowed to create Employee" do
    ep = Employee.create_object(
      :name => @name_1,
      :description => @description_1,
      :contact_no => @contact_no_1,
      :address => @address_1,
      :email => @email_1,
    )
    
    ep.should be_valid
    ep.errors.size.should == 0 
  end
  
  it "should not create Employee without name" do
    ep = Employee.create_object(
      :name => nil,
      :description => @description_1,
      :contact_no => @contact_no_1,
      :address => @address_1,
      :email => @email_1,
      )
    
    ep.errors.size.should_not == 0 
    ep.should_not be_valid
    
  end
  
  it "should not create Employee if name present, but length == 0 " do
    ep = Employee.create_object(
      :name => "",
      :description => @description_1,
      :contact_no => @contact_no_1,
      :address => @address_1,
      :email => @email_1,
    )
    
    ep.errors.size.should_not == 0 
    ep.should_not be_valid
    
  end
  
  
  context "Create New Employee" do
    before (:each) do
      @ep = Employee.create_object(
        :name => @name_1,
        :description => @description_1,
        :contact_no => @contact_no_1,
        :address => @address_1,
        :email => @email_1,
        )
    end
    
    it "should create Employee" do
      @ep.errors.size.should == 0
      @ep.should be_valid
    end
    
    it "cannot update object if name not valid" do
      @ep.update_object(
        :name => nil,
        :description => @description_2,
        :contact_no => @contact_no_2,
        :address => @address_2,
        :email => @email_2,
     )
     @ep.errors.size.should_not == 0 
     @ep.should_not be_valid
    end
    
    it "cannot update object if name present, but length == 0" do
      @ep.update_object(
        :name => "",
        :description => @description_2,
        :contact_no => @contact_no_2,
        :address => @address_2,
        :email => @email_2,
        )
      @ep.errors.size.should_not == 0 
      @ep.should_not be_valid
    end   
    
    it "should update object" do
      @ep.update_object(
        :name => @name_2,
        :description => @description_2,
        :contact_no => @contact_no_2,
        :address => @address_2,
        :email => @email_2,
      )
      @ep.name.should == @name_2
      @ep.description.should == @description_2
      @ep.contact_no.should == @contact_no_2
      @ep.address.should == @address_2
      @ep.email.should == @email_2
    end
  
    it "should delete object" do
      @ep.delete_object
      Employee.count.should == 0
    end
  end
  
end
