require 'spec_helper'

class SimpleExample
  include HashAccessor

  hash_accessor :foo, :yin
end

class StrictExample
  include HashAccessor

  hash_accessor :foo, :yin, strict: true
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
      end

      it "should allow no attributes to be supplied" do
        simple = SimpleExample.new
        expect(simple.foo).to eq(nil)
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
  end
end
