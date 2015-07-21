require 'spec_helper'

describe BatchSourceAllocation do
  
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
    
    @itp_1 =  ItemType.where(:is_batched => true ).first
    
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
    
    @item_1 = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku1",
      :name => "itemname1",
      :description => "description_1",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("10"),
      :selling_price => BigDecimal("1000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    @adjustment_date_1 = DateTime.now
    @adjustment_date_2 = DateTime.now + 1.days
    @description_1 = "Description1"
    @description_2 = "Description2"
  
    @sa = StockAdjustment.create_object(
    :warehouse_id => @wrh_1.id,
    :adjustment_date => @adjustment_date_1,
    :description => @description_1
    )
    
    @initial_amount = BigDecimal("10")
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa.id,
      :item_id => @item_1.id,
      :price => BigDecimal("5000"),
      :amount => @initial_amount,
      :status => ADJUSTMENT_STATUS[:addition]
      )
    @sa.confirm_object(:confirmed_at => DateTime.now)
    @item_1.reload
    
    @batch_instance_1 =    BatchInstance.create_object(
            :item_id         => @item_1.id , 
            :name            => "Roll A", 
            :description     => "The description" ,   
            :manufactured_at => DateTime.now 
        )
        
    @batch_instance_2 =    BatchInstance.create_object(
            :item_id         => @item_1.id , 
            :name            => "Roll B", 
            :description     => "The description" ,   
            :manufactured_at => DateTime.now 
        )
        
    @batch_instance_3 =    BatchInstance.create_object(
            :item_id         => @item_1.id , 
            :name            => "Roll c", 
            :description     => "The description" ,   
            :manufactured_at => DateTime.now 
        )
        
    @batch_source = BatchSource.first 
  end
  
  it "should have batch_source" do
    BatchSource.count.should_not == 0
    @batch_source.should be_valid 
    
    @batch_source.unallocated_amount.should == @batch_source.amount
    @batch_source.unallocated_amount.should == @initial_amount
  end
  
  it "should have batch instance" do
    @batch_instance_1.should be_valid 
    @batch_instance_2.should be_valid 
    @batch_instance_3.should be_valid 
  end
  
  it "should be allowed to create batch_source_allocation" do
    @allocated_amount = @initial_amount - BigDecimal('5')
    @allocation = BatchSourceAllocation.create_object(
        :batch_instance_id => @batch_instance_1.id, 
        :amount => @allocated_amount,
        :batch_source_id => @batch_source.id 
      )
    @allocation.should be_valid
  end
  
  it "should not be allowed to allocate more than available" do
    @allocated_amount = @initial_amount + BigDecimal('5')
    @allocation = BatchSourceAllocation.create_object(
        :batch_instance_id => @batch_instance_1.id, 
        :amount => @allocated_amount,
        :batch_source_id => @batch_source.id 
      )
    @allocation.should_not be_valid
  end
  
  context "creating allocation" do
    before(:each) do  
      @initial_unallocated_amount = @batch_source.unallocated_amount
      
      @allocated_amount =   BigDecimal('5')
      @allocation = BatchSourceAllocation.create_object(
          :batch_instance_id => @batch_instance_1.id, 
          :amount => @allocated_amount,
          :batch_source_id => @batch_source.id 
        )
      @batch_source.reload 
    end
    
    it "should create one batch stock mutation " do
      BatchStockMutation.count.should == 1 
      result = BatchStockMutation.where(
          :batch_instance_id => @batch_instance_1.id ,
          :source_id => @allocation.id,
          :source_class => @allocation.class.to_s
        ).first
        
      result.status = @allocation.batch_source.status  
    end
    
    it "should deduct batch_source.unallocated_amount" do
      
      
      
      diff = @initial_unallocated_amount - @batch_source.unallocated_amount 
      
      diff.should == @allocated_amount
    end
    
    context "destroy allocation" do
      before(:each) do 
        @unallocated_amount_before_destroy = @batch_source.unallocated_amount
        
        @allocation.delete_object
        @batch_source.reload 
      end
      
      it "should delete allocation" do
        @allocation.persisted?.should be_falsy
      end
      
      it "should increase the unallocated_amount" do
        puts "final_unallocated: #{@batch_source.unallocated_amount.to_s}"
        puts "before destroy unallocated : #{@unallocated_amount_before_destroy.to_s}"
        diff = @batch_source.unallocated_amount - @unallocated_amount_before_destroy
        diff.should == @allocated_amount
        
      end
    end
  end
   
end


# can't allocate more than amount 
# must create batch_stock_mutation on allocation create 
# must delete batch_stock_mutation on allocation destroy 