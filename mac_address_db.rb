class MacAddressDB

  def initialize
    @db = {}
  end

  # load data from a MAC address database txt file. Data is cumulatively added if
  # this is called multiple times.
  def load_data(filename)
    File.readlines(filename).each do |line|
      # prevent 'invalid byte sequence in UTF-8' errors by forcing encoding
      line = line.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      # strip comments
      line = line.chomp.gsub(/(#.+)$/, '').strip

      unless line.empty? or line.nil?
        mac, vendor = line.split(/\t/, 2)
        @db[mac] = vendor
      end
    end
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
      if @db[mac_partial]
        vendor = @db[mac_partial]
        break
      end
    end
    vendor
  end

  def dump
    @db.each do |mac, vendor|
      puts "#{mac}\t#{vendor}"
    end
  end

  # return the number of entries in the MAC database
  def size
    @db.length
  end
end
