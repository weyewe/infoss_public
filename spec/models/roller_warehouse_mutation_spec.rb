require 'spec_helper'

describe RollerWarehouseMutation do
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
     
    @machine_1 = Machine.create_object(
      :code => "code_1",
      :name => "name_1",
      :description => "description_1"
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
    
    @rif = RollerIdentificationForm.create_object(
      :warehouse_id => @wrh_1.id,
      :contact_id => @ct_1.id,
      :is_in_house => true,
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
    
    @rb = RollerBuilder.create_object(
        :base_sku => "base123",
        :name => "name Or",
        :description => "123123",
        :uom_id => @uom_1.id,
        :adhesive_id => @adhesive_1.id,
        :compound_id => @compound_1.id,
        :machine_id => @machine_1.id,
        :roller_type_id => @roller_type_1.id,
        :core_builder_id => @core_builder_1.id,
        :is_grooving => true,
        :is_crowning => true,
        :is_chamfer => true,
        :crowning_size => BigDecimal("10"),
        :grooving_width => BigDecimal("10"),
        :grooving_depth => BigDecimal("10"),
        :grooving_position => BigDecimal("10"),
        :cd =>  BigDecimal("10"),
        :rd =>  BigDecimal("10"),
        :rl =>  BigDecimal("10"),
        :wl =>  BigDecimal("10"),
        :tl =>  BigDecimal("10")
        )
    
    
    @ro = RecoveryOrder.create_object(
        :roller_identification_form_id => @rif.id,
        :warehouse_id => @wrh_1.id,
        :code => "code_1",
        :has_due_date => true,
        :due_date => DateTime.now,
        )
    @rod = RecoveryOrderDetail.create_object(
        :recovery_order_id => @ro.id,
        :roller_identification_form_detail_id => @rifd.id,
        :roller_builder_id => @rb.id,
        :core_type_case => CORE_TYPE_CASE[:r],
        )    
    @ro.confirm_object(:confirmed_at => DateTime.now)   
    @rod.finish_object(:finished_date => DateTime.now)
    
    end
    context "create RollerWarehouseMutation" do
      before(:each) do 
        @rwm = RollerWarehouseMutation.create_object(
          :recovery_order_id => @ro.id,
          :warehouse_from_id => @wrh_1.id,
          :warehouse_to_id => @wrh_2.id,
          :mutation_date => DateTime.now
          )
      end
      
      it "should create RollerWarehouseMutation" do
        @rwm.errors.size.should == 0
        @rwm.should be_valid
      end
      
      context "create RollerWarehouseMutationDetail" do
        before(:each) do
          @rwmd = RollerWarehouseMutationDetail.create_object(
            :roller_warehouse_mutation_id => @rwm.id,
            :recovery_order_detail_id => @rod.id,
            )
        end
        
        it "should create RollerWarehouseMutationDetail" do
          @rwmd.errors.size.should == 0
          @rwmd.should be_valid
        end
        
        context "confirm RollerWarehouseMutation" do
          before(:each) do
            @rwm.confirm_object(:confirmed_at => DateTime.now)
          end
          
          it "should confirm RollerWarehouseMutation" do
            @rwm.is_confirmed.should == true
          end
          
          context "unconfirm RollerWarehouseMutation" do
            before(:each) do
              @rwm.unconfirm_object
            end
            
            it "shoulld unconfirm RollerWarehouseMutation" do
              @rwm.is_confirmed.should == false
            end
            
          end
          
          
        end
      end
    
  end
end
