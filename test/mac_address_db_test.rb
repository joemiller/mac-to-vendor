require 'test_helper'

fixture_dir = File.join(File.dirname(__FILE__), 'fixtures')

describe 'MacAddressDB' do

  before do
    @db = MacAddressDB.new
    Dir[File.join(fixture_dir, '**', '*.txt')].each do |f|
      @db.load_data(f)
    end
  end

  it 'returns the size of the database' do
    @db.size.must_equal 18
  end

  it 'returns the vendor name for a known MAC addr' do
    vendor = @db.lookup('52:54:00:11:22:aa')
    vendor.must_equal 'QEMU'
  end

  it 'returns nil when looking up an unknown MAC addr' do
    vendor = @db.lookup('99:99:99:99:99:99')
    assert_nil vendor
  end

end
