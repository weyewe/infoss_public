require 'spec_helper'

describe BlanketOrder do
  before(:each) do
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
      :description => "description_2"
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
      :name => "RollBlanket" ,
      :description => "Description1",
      :account_id => @coa_1.id
      )
    
    @itp_2 = ItemType.create_object(
      :name => "Adhesive" ,
      :description => "Description1",
      :account_id => @coa_1.id
      )
    
    @itp_3 = ItemType.create_object(
      :name => "Bar" ,
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
    
    @blanket_1 = Blanket.create_object(
      :sku => "sku blanket",
      :name => "blanket name",
      :description => "desc",
      :uom_id => @uom_1.id,
      :roll_no => @roll_no_1,
      :contact_id => @ct_1.id,
      :machine_id => @machine_1.id,
      :adhesive_id => @adhesive_1.id,
      :adhesive2_id => @adhesive_2.id,
      :roll_blanket_item_id => @roll_blanket_1.id,
      :left_bar_item_id => @bar_1.id,
      :right_bar_item_id => @bar_2.id,
      :ac => BigDecimal("10"),
      :ar => BigDecimal("10"),
      :thickness => BigDecimal("10"),
      :is_bar_required => true,
      :cropping_type => CROPPING_TYPE[:normal],
      :special => BigDecimal("10"),
      :application_case =>  APPLICATION_CASE[:sheetfed],
      :left_over_ac => BigDecimal("10"),
      :left_over_ar => BigDecimal("10"),
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("2000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    
    @wrh_1 = Warehouse.create_object(
        :name => "name_1" ,
        :description => "description_1",
        :code => "code_1"
      )
      
    @wrh_2 = Warehouse.create_object(
        :name => "name_2" ,
        :description => "description_1",
        :code => "code_2"
      )
    
    @sa_1 = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => DateTime.now,
      :description => @description_1
      )
     
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @blanket_1.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
     
    @sad_2 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @bar_1.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
      
    @sad_3 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @bar_2.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    
    @sad_4 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @roll_blanket_1.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    
    @sa_1.confirm_object(:confirmed_at => DateTime.now)
    
    @production_no_1 = "production_no_1"
    @production_no_2 = "production_no_2"
    @order_date_1 = DateTime.now
    @order_date_2 = DateTime.now + 1.days
    @notes_1 = "Notes1"
    @notes_2 = "Notes2"
    @has_due_date_1 = true
    @has_due_date_2 = false
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
  end
  
  it "Should not create BlanketOrder if contact_id is not valid" do
    bo = BlanketOrder.create_object(
      :contact_id => 12321,
      :warehouse_id => @wrh_1.id,
      :order_date => @order_date_1,
      :production_no => @production_no_1,
      :has_due_date => @has_due_date_1,
      :due_date => @due_date_1,
      )
    bo.errors.size.should_not == 0
    bo.should_not be_valid
  end
  
  it "Should not create BlanketOrder if warehouse_id is not valid" do
    bo = BlanketOrder.create_object(
      :contact_id => @ct_1.id,
      :warehouse_id => 1232131,
      :order_date => @order_date_1,
      :production_no => @production_no_1,
      :has_due_date => @has_due_date_1,
      :due_date => @due_date_1,
      )
    bo.errors.size.should_not == 0
    bo.should_not be_valid
  end
  
  it "Should not create BlanketOrder if order_date is not valid" do
    bo = BlanketOrder.create_object(
      :contact_id => @ct_1.id,
      :warehouse_id => @wrh_1.id,
      :order_date => nil,
      :production_no => @production_no_1,
      :has_due_date => @has_due_date_1,
      :due_date => @due_date_1,
      )
    bo.errors.size.should_not == 0
    bo.should_not be_valid
  end
  
  it "Should not create BlanketOrder if production_no is not valid" do
    bo = BlanketOrder.create_object(
      :contact_id => @ct_1.id,
      :warehouse_id => @wrh_1.id,
      :order_date => @order_date_1,
      :production_no => nil,
      :has_due_date => @has_due_date_1,
      :due_date => @due_date_1,
      )
    bo.errors.size.should_not == 0
    bo.should_not be_valid
  end
  
  context "Create BlanketOrder" do
    before(:each) do
      @bo = BlanketOrder.create_object(
        :contact_id => @ct_1.id,
        :warehouse_id => @wrh_1.id,
        :order_date => @order_date_1,
        :production_no => @production_no_1,
        :has_due_date => @has_due_date_1,
        :due_date => @due_date_1,
        )
    end
    
    it "should create BlanketOrder" do
      @bo.errors.size.should == 0
      @bo.should be_valid
    end
    
    it "should not update BlanketOrder if contact_id is not valid" do
      @bo.update_object(
        :contact_id => 123123,
        :warehouse_id => @wrh_2.id,
        :order_date => @order_date_2,
        :production_no => @production_no_2,
        :has_due_date => @has_due_date_2,
        :due_date => @due_date_2,
        )
      @bo.errors.size.should_not == 0
      @bo.should_not be_valid
    end
    
    it "should not update BlanketOrder if warehouse_id is not valid" do
      @bo.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => 123123,
        :order_date => @order_date_2,
        :production_no => @production_no_2,
        :has_due_date => @has_due_date_2,
        :due_date => @due_date_2,
        )
      @bo.errors.size.should_not == 0
      @bo.should_not be_valid
    end
    
    it "should not update BlanketOrder if order_date is not valid" do
      @bo.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => @wrh_2.id,
        :order_date => nil,
        :production_no => @production_no_2,
        :has_due_date => @has_due_date_2,
        :due_date => @due_date_2,
        )
      @bo.errors.size.should_not == 0
      @bo.should_not be_valid
    end
    
    it "should not update BlanketOrder if production_no is not valid" do
      @bo.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => @wrh_2.id,
        :order_date => @order_date_2,
        :production_no => nil,
        :has_due_date => @has_due_date_2,
        :due_date => @due_date_2,
        )
      @bo.errors.size.should_not == 0
      @bo.should_not be_valid
    end
    
    it "should update BlanketOrder" do
      @bo.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => @wrh_2.id,
        :order_date => @order_date_2,
        :production_no => @production_no_2,
        :has_due_date => @has_due_date_2,
        :due_date => @due_date_2,
        )
      @bo.errors.size.should == 0
      @bo.contact_id.should == @ct_2.id
      @bo.warehouse_id.should == @wrh_2.id
      @bo.order_date.should == @order_date_2
      @bo.production_no.should == @production_no_2
      @bo.has_due_date.should == @has_due_date_2
    end
    
    
    it "should delete BlanketOrder" do
      @bo.delete_object
      @bo.errors.size.should == 0
      BlanketOrder.count.should == 0
    end
    
    context "Create BlanketOrderDetail" do
      before(:each) do
        @quantity = 5 
        @bod = BlanketOrderDetail.create_object(
          :blanket_order_id => @bo.id,
          :blanket_id => @blanket_1.id,
          :quantity => @quantity 
          )
      end
      
      it "should create BlanketOrderDetail" do
        @bod.errors.size.should == 0
        @bod.should be_valid
      end
      
      it "should not update BlanketOrder" do
        @bo.update_object(
          :contact_id => @ct_2.id,
          :warehouse_id => @wrh_2.id,
          :order_date => @order_date_2,
          :production_no => nil,
          :has_due_date => @has_due_date_2,
          :due_date => @due_date_2,
          )
        @bo.errors.size.should_not == 0
      end
      
      it "should not delete BlanketOrder" do
          @bo.delete_object
          @bo.errors.size.should_not == 0
      end
      
      context "Confirm BlanketOrder" do
        before(:each) do
          @bo.confirm_object(
            :confirmed_at => DateTime.now
            )
        end
        
        it "should confirm BlanketOrder" do
          @bo.errors.size.should == 0
          @bo.is_confirmed == true
        end
        
        it "should not delete BlanketOrder" do
          @bo.delete_object
          @bo.errors.size.should_not == 0
        end
        
        context "Unconfirm BlanketOrder" do
          before(:each) do
            @bo.unconfirm_object
          end
          
          it "should unconfirm BlanketOrder" do
            @bo.is_confirmed == false
          end
          
        end
        
      end
      
      
    end
    
  end
end
