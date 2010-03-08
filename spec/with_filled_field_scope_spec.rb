require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'active_record_connectionless'

class WithFilledFieldScopeModel < ActiveRecord::Base
  has_with_filled_field_scope
end

describe 'WithFilledFieldScopeModel' do

  describe 'field_column_type' do
    before do
      @name_column = mock(ActiveRecord::ConnectionAdapters::Column)
      @columns_hash = {'name' => @name_column}
    end

    it 'should read column type from models column hash' do
      @name_column.should_receive(:type).and_return(:name_column_type)
      WithFilledFieldScopeModel.should_receive(:columns_hash).and_return(@columns_hash)
      WithFilledFieldScopeModel.field_column_type(:name).should == :name_column_type
    end

    it 'should allow to change model' do
      @name_column.should_receive(:type).and_return(:name_column_type)
      changed_model = mock(ActiveRecord::Base)
      changed_model.should_receive(:columns_hash).and_return(@columns_hash)
      WithFilledFieldScopeModel.field_column_type(:name, changed_model).should == :name_column_type
    end
  end

  describe 'field_support_not_blank?' do
    it 'should be false for date' do
      WithFilledFieldScopeModel.should_receive(:field_column_type).with(:field).and_return(:date)
      WithFilledFieldScopeModel.field_support_not_blank?(:field).should be_false
    end

    it 'should be false for decimal' do
      WithFilledFieldScopeModel.should_receive(:field_column_type).with(:field).and_return(:decimal)
      WithFilledFieldScopeModel.field_support_not_blank?(:field).should be_false
    end

    it 'should be false for boolean' do
      WithFilledFieldScopeModel.should_receive(:field_column_type).with(:field).and_return(:boolean)
      WithFilledFieldScopeModel.field_support_not_blank?(:field).should be_false
    end

    it 'should be true for string' do
      WithFilledFieldScopeModel.should_receive(:field_column_type).with(:field).and_return(:string)
      WithFilledFieldScopeModel.field_support_not_blank?(:field).should be_true
    end
  end

  describe 'with_filled_field scope' do
    it 'should use not null scope when field does not support not blank' do
      WithFilledFieldScopeModel.should_receive(:field_support_not_blank?).with(:field, WithFilledFieldScopeModel).and_return(false)
      WithFilledFieldScopeModel.should_receive(:field_not_null)
      WithFilledFieldScopeModel.with_filled_field(:field)
    end

    it 'should use not blank scope when field support not blank' do
      WithFilledFieldScopeModel.should_receive(:field_support_not_blank?).with(:field, WithFilledFieldScopeModel).and_return(true)
      WithFilledFieldScopeModel.should_receive(:field_not_blank)
      WithFilledFieldScopeModel.with_filled_field(:field)
    end
  end

end

