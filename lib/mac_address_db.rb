require 'sqlite3'

class MacAddressDB

  def initialize(filename)
    @filename = filename
    setup
  end

  def reset
    @db.execute('DROP TABLE IF EXISTS vendors')
    setup
  end

  # load data from a MAC address database txt file. Data is cumulatively added if
  # this is called multiple times.
  def load_data(filename)
    @db.execute('BEGIN')
    File.readlines(filename).each do |line|
      # prevent 'invalid byte sequence in UTF-8' errors by forcing encoding
      # line = line.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      # strip comments
      line = line.chomp.gsub(/(#.+)$/, '').strip

      unless line.empty? or line.nil?
        mac, vendor = line.split(/\t/, 2)
        # @db[mac] = vendor
        @db.execute('REPLACE INTO vendors (addr, vendor) VALUES (?, ?)', [mac, vendor])
      end
    end
    @db.execute('END')
  end

  # given a MAC address, return the vendor (string) that it belongs to.
  # returns nil if no match.
  # search through the MAC database looking for most-specific to least-specific matches.
  # mac address format is flexible: eg: '00:22:4d:88:58:a0', '00224d8858a0', etc.
  def lookup(mac)
    # upper-case mac addr and strip colons
    mac = mac.gsub(/:/, '').upcase
    vendor = nil

    len = mac.length
    len.times do |x|
      # @TODO(joe): it's probably OK to optimize this by searching in slices of 2 instead of 1
      mac_partial = mac[0, len - x]
      v = @db.get_first_value('SELECT vendor FROM vendors WHERE addr = ?', [mac_partial])
      if !v.nil?
        vendor = v
        break
      end
      # if @db[mac_partial]
      #   vendor = @db[mac_partial]
      #   break
      # end
    end
    vendor
  end

  def dump
    @db.execute('SELECT (addr, vendor) FROM vendors').each do |row|
      puts "#{row[0]}\t#{row[1]}"
    end

  end

  # return the number of entries in the MAC database
  def size
    @db.get_first_value('SELECT COUNT(*) FROM vendors')
  end

  private

  def setup
    @db.close if defined?(@db)
    @db = SQLite3::Database.new(@filename)
    @db.execute('CREATE TABLE IF NOT EXISTS vendors(addr TEXT UNIQUE, vendor TEXT)')
  end

end
