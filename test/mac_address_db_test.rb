require 'test_helper'

TEMP_DB = 'testdb.sqlite'

fixture_dir = File.join(File.dirname(__FILE__), 'fixtures')

describe 'MacAddressDB' do

  before do
    @db = MacAddressDB.new(TEMP_DB)
    Dir[File.join(fixture_dir, '**', '*.txt')].each do |f|
      @db.load_data(f)
    end
  end

  after(:all) do
    File.unlink(TEMP_DB)
  end

  it 'returns the size of the database' do
    _(@db.size).must_equal 18
  end

  it 'returns the vendor name for a known MAC addr' do
    vendor = @db.lookup('52:54:00:11:22:aa')
    _(vendor).must_equal 'QEMU'
  end

  it 'returns nil when looking up an unknown MAC addr' do
    vendor = @db.lookup('99:99:99:99:99:99')
    assert_nil vendor
  end

  it 'removes all entries when reset is called' do
    @db.reset
    _(@db.size).must_equal 0
  end

end
