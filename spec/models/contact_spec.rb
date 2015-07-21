require 'spec_helper'

describe Contact do
  before (:each) do
    @name_1 = "Contact1"
    @name_2 = "Contact2"
    @address_1= "address1"
    @address_2 = "address2"
    @delivery_address_1 = "delivery_address1"
    @delivery_address_2 = "delivery_address2"
    @description_1 = "description1"
    @description_2 = "description2"
    @npwp_1 = "npwp1"
    @npwp_2 = "npwp2"
    @contact_no_1 = "0212345"
    @contact_no_2 = "0212346"
    @pic_1 = "pic1"
    @pic_2 = "pic2"
    @pic_contact_no_1 = "0987654"
    @pic_contact_no_2 = "2837123"
    @email_1 = "email1"
    @email_2 = "email2"
    @is_taxable_1 = true
    @is_taxable_2 = false
    @tax_code_1 = TAX_CODE[:code_01]
    @tax_code_2 = TAX_CODE[:code_01]
    @contact_type = CONTACT_TYPE[:customer]
    @default_payment_term_1 = 0
    @default_payment_term_2 = 30
    @nama_faktur_pajak_1 = "Nama pajak1"
    @nama_faktur_pajak_2 = "Nama pajak2"
    @cg_1 = ContactGroup.create_object(
        :name => "Group1" ,
      :description => "Description1"
      )
    @cg_2 = ContactGroup.create_object(
        :name => "Group2" ,
      :description => "Description2"
      )   
  end
  
  it "should be allowed to create Contact" do
    ct = Contact.create_object(
      :name => @name_1,
      :address => @address_1,
      :delivery_address => @delivery_address_1,
      :description => @description_1,
      :npwp => @npwp_1,
      :contact_no => @contact_no_1,
      :pic => @pic_1,
      :pic_contact_no => @pic_contact_no_1,
      :email => @email_1,
      :is_taxable => @is_taxable_1,
      :tax_code => @tax_code_1,
      :contact_type => @contact_type,
      :default_payment_term => @default_payment_term_1,
      :nama_faktur_pajak => @nama_faktur_pajak_1,
      :contact_group_id => @cg_1.id
    )
    
    ct.should be_valid
    ct.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    ct = Contact.create_object(
      :name => nil ,
      :address => @address_1,
      :delivery_address => @delivery_address_1,
      :description => @description_1,
      :npwp => @npwp_1,
      :contact_no => @contact_no_1,
      :pic => @pic_1,
      :pic_contact_no => @pic_contact_no_1,
      :email => @email_1,
      :is_taxable => @is_taxable_1,
      :tax_code => @tax_code_1,
      :contact_type => @contact_type,
      :default_payment_term => @default_payment_term_1,
      :nama_faktur_pajak => @nama_faktur_pajak_1,
      :contact_group_id => @cg_1.id
      )
    
    ct.errors.size.should_not == 0 
    ct.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    ct = Contact.create_object(
      :name => "" ,
      :address => @address_1,
      :delivery_address => @delivery_address_1,
      :description => @description_1,
      :npwp => @npwp_1,
      :contact_no => @contact_no_1,
      :pic => @pic_1,
      :pic_contact_no => @pic_contact_no_1,
      :email => @email_1,
      :is_taxable => @is_taxable_1,
      :tax_code => @tax_code_1,
      :contact_type => @contact_type,
      :default_payment_term => @default_payment_term_1,
      :nama_faktur_pajak => @nama_faktur_pajak_1,
      :contact_group_id => @cg_1.id
    )
    
    ct.errors.size.should_not == 0 
    ct.should_not be_valid
    
  end
  
  
  context "Create New Contact" do
    before (:each) do
      @ct = Contact.create_object(
        :name => @name_1 ,
        :address => @address_1,
        :delivery_address => @delivery_address_1,
        :description => @description_1,
        :npwp => @npwp_1,
        :contact_no => @contact_no_1,
        :pic => @pic_1,
        :pic_contact_no => @pic_contact_no_1,
        :email => @email_1,
        :is_taxable => @is_taxable_1,
        :tax_code => @tax_code_1,
        :contact_type => @contact_type,
        :default_payment_term => @default_payment_term_1,
        :nama_faktur_pajak => @nama_faktur_pajak_1,
        :contact_group_id => @cg_1.id
      )
    end
    
    it "should create Contact" do
      @ct.errors.size.should == 0
      @ct.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @ct.update_object(
      :name => nil,
      :address => @address_1,
      :delivery_address => @delivery_address_1,
      :description => @description_1,
      :npwp => @npwp_1,
      :contact_no => @contact_no_1,
      :pic => @pic_1,
      :pic_contact_no => @pic_contact_no_1,
      :email => @email_1,
      :is_taxable => @is_taxable_1,
      :tax_code => @tax_code_1,
      :contact_type => @contact_type,
      :default_payment_term => @default_payment_term_1,
      :nama_faktur_pajak => @nama_faktur_pajak_1,
      :contact_group_id => @cg_1.id
     )
     @ct.errors.size.should_not == 0 
     @ct.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @ct.update_object(
      :name => "",
      :address => @address_1,
      :delivery_address => @delivery_address_1,
      :description => @description_1,
      :npwp => @npwp_1,
      :contact_no => @contact_no_1,
      :pic => @pic_1,
      :pic_contact_no => @pic_contact_no_1,
      :email => @email_1,
      :is_taxable => @is_taxable_1,
      :tax_code => @tax_code_1,
      :contact_type => @contact_type,
      :default_payment_term => @default_payment_term_1,
      :nama_faktur_pajak => @nama_faktur_pajak_1,
      :contact_group_id => @cg_1.id
     )
     @ct.errors.size.should_not == 0 
     @ct.should_not be_valid
    end   
    
    it "should update object" do
      @ct.update_object(
        :name => @name_2 ,
        :address => @address_2,
        :delivery_address => @delivery_address_2,
        :description => @description_2,
        :npwp => @npwp_2,
        :contact_no => @contact_no_2,
        :pic => @pic_2,
        :pic_contact_no => @pic_contact_no_2,
        :email => @email_2,
        :is_taxable => @is_taxable_2,
        :tax_code => @tax_code_2,
        :contact_type => @contact_type,
        :default_payment_term => @default_payment_term_2,
        :nama_faktur_pajak => @nama_faktur_pajak_2,
        :contact_group_id => @cg_2.id
      )
      @ct.name.should == @name_2
      @ct.address.should == @address_2
      @ct.delivery_address.should == @delivery_address_2
      @ct.description.should == @description_2
      @ct.npwp.should == @npwp_2
      @ct.contact_no.should == @contact_no_2
      @ct.pic.should == @pic_2
      @ct.pic_contact_no.should == @pic_contact_no_2
      @ct.email.should == @email_2
      @ct.is_taxable.should == @is_taxable_2
      @ct.tax_code.should == @tax_code_2
      @ct.contact_type.should == @contact_type
      @ct.default_payment_term.should == @default_payment_term_2
      @ct.nama_faktur_pajak.should == @nama_faktur_pajak_2
      @ct.contact_group_id.should == @cg_2.id
    end
  
    it "should delete contact" do
      @ct.delete_object 
      Contact.count.should == 0
    end
    
  end
end
