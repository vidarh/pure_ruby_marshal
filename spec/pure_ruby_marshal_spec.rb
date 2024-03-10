require 'spec_helper'

describe PureRubyMarshal do
  
  describe '.dump' do
    FIXTURES.each do |fixture_name, fixture_value|
      it "produces identical dump to Marshal for #{fixture_name}" do
        prm = PureRubyMarshal.dump(fixture_value)
        mri = Marshal.dump(fixture_value)
        if fixture_value.is_a?(Float)
          expect(prm.to_s).to eq(mri.to_s)
        else
          expect(prm).to eq(mri)
        end
      end
    end

    FIXTURES.each do |fixture_name, fixture_value|
      it "writes marshalled #{fixture_name}" do
        marshalled = PureRubyMarshal.dump(fixture_value)
        loaded = Marshal.load(marshalled)
        if fixture_value.is_a?(Float)
          expect(loaded.to_s).to eq(fixture_value.to_s)
        else
          expect(loaded.inspect).to eq(fixture_value.inspect)
        end
      end
    end
  end

  describe '.load' do
    FIXTURES.each do |fixture_name, fixture_value|
      it "loads marshalled #{fixture_name}" do
        dumped = Marshal.dump(fixture_value)
        result = PureRubyMarshal.load(dumped)
        if fixture_value.is_a?(Float)
          expect(result.to_s).to eq(fixture_value.to_s)
        else
          expect(result.inspect).to eq(fixture_value.inspect)
        end
      end
    end

    it 'loads marshalled extended object' do
      object = [].extend(MyModule)
      dump = Marshal.dump(object)
      result = PureRubyMarshal.load(dump)
      expect(result).to be_a(MyModule)
    end
  end
end
