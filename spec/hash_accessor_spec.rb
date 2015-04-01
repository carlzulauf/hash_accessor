require 'spec_helper'

class SimpleExample
  include HashAccessor
  hash_accessor :foo, :yin
end

class StrictExample
  include HashAccessor
  hash_accessor :foo, :yin, strict: true
end

class ParentExample
  include HashAccessor
  hash_accessor :foo, :bar
end

class ChildExample < ParentExample
  hash_accessor :yin, :yang
end

describe HashAccessor do
  it 'has a version number' do
    expect(HashAccessor::VERSION).not_to be nil
  end

  describe ".hash_accessor" do
    let(:attributes) { {foo: "bar", yin: "yang", tea: "time"} }

    context "with simple class" do
      context "and attributes" do
        subject { SimpleExample.new(attributes) }

        it "should return the proper values for #foo and #yin" do
          expect(subject.foo).to eq("bar")
          expect(subject.yin).to eq("yang")
        end

        it "should not define methods for unregistered attributes" do
          expect{ subject.tea }.to raise_error(NameError)
        end

        it "should not interfere with attributes in another instance" do
          other = SimpleExample.new(foo: "good")
          expect(subject.foo).to eq("bar")
          expect(other.foo).to eq("good")
          expect(other.yin).to eq(nil)
        end
      end

      context "and no attributes" do
        subject { SimpleExample.new }

        it "should allow no attributes to be supplied" do
          expect(subject.foo).to eq(nil)
        end

        it "should provide functional accessors" do
          subject.foo = "bar"
          expect(subject.foo).to eq("bar")
        end
      end

      context "and string key attributes" do
        subject { SimpleExample.new("foo" => "bar", "yin" => "yang") }

        it "should return the proper values for #foo and #yin" do
          expect(subject.foo).to eq("bar")
          expect(subject.yin).to eq("yang")
        end
      end
    end

    context "with strict class" do
      describe "#initialize" do
        it "should raise an argument error when extra attributes are present" do
          expect { StrictExample.new(attributes) }.to raise_error(ArgumentError)
        end

        it "should allow no attributes to be supplied" do
          strict = StrictExample.new
          expect(strict.foo).to eq(nil)
        end

        it "should initialize with attribute values correctly" do
          strict = StrictExample.new(foo: "bar")
          expect(strict.foo).to eq("bar")
        end
      end
    end

    context "with inheritance" do
      let(:parent) { ParentExample.new(foo: "father", bar: "mother") }
      let(:child) { ChildExample.new(foo: "son", bar: "daughter", yin: 123, yang: 321) }

      describe "parent" do
        it "should not have accessors defined in child" do
          expect(parent.respond_to?(:yin)).to eq(false)
          expect{ parent.yin }.to raise_error(NameError)
        end
      end

      describe "child" do
        it "should inherit parent accessors" do
          expect(child.respond_to?(:foo)).to eq(true)
        end

        it "should contain values assigned to child" do
          expect(child.foo).to eq("son")
          expect(child.bar).to eq("daughter")
        end

        it "should possess accessors added within child" do
          expect(child.yin).to eq(123)
          expect(child.yang).to eq(321)
        end
      end
    end
  end
end
