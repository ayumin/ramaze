require 'spec'
require File.expand_path(__FILE__).gsub(/\/spec\//, '/lib/ramaze/')

describe 'Array#put_within' do
  it 'should put a given object at a well-described position' do
    array = [:foo, :bar, :baz]
    array.put_within(:foobar, :after => :bar, :before => :baz)
    array.should == [:foo, :bar, :foobar, :baz]
  end

  it 'should raise on uncertainity' do
    array = [:foo, :bar, :baz]
    lambda{
      array.put_within(:foobar, :after => :foo, :before => :baz)
    }.should raise_error(ArgumentError, "Too many elements within constrain")
  end
end

describe 'Array#put_after' do
  it 'should put a given object at a well-described position' do
    array = [:foo, :bar, :baz]
    array.put_after(:bar, :foobar)
    array.should == [:foo, :bar, :foobar, :baz]
  end
end

describe 'Array#put_within' do
  it 'should put a given object at a well-described position' do
    array = [:foo, :bar, :baz]
    array.put_before(:bar, :foobar)
    array.should == [:foo, :foobar, :bar, :baz]
  end
end
