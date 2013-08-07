require "dovecot_crammd5/version"
require 'digest/md5'

module DovecotCrammd5
  MASK = 0xffffffff
  def self.rotate_left_shift_32bit(i, n)
    i = MASK & i
    i = (MASK & (i << n)) | (i >> (32 - n))
  end

  def self.int64tobinstr_le(i64)
    [MASK & i64].pack("V") + [i64 >> 32].pack("V")
  end

  def self.binstr2int_le(str)
    str.unpack("V")[0]
  end

  def self.str_xor(str, xor)
    ret = ""
    (0..63).each do |i|
      c = str[i] == nil ? 0 : str.getbyte(i)
      ret = ret + (c ^ xor).chr
    end
    return ret
  end

  def self.hexdigest(str)
    a = binstr2int_le([0x01, 0x23, 0x45, 0x67].pack("C4"))
    b = binstr2int_le([0x89, 0xab, 0xcd, 0xef].pack("C4"))
    c = binstr2int_le([0xfe, 0xdc, 0xba, 0x98].pack("C4"))
    d = binstr2int_le([0x76, 0x54, 0x32, 0x10].pack("C4"))

    f_a = []
    t_a = []
    k_a = []
    s_a = []
    n4_a = []
    (1..64).each do |i|
      t_a[i] = (Math.sin(i).abs * 4294967296).truncate
      n4_a[i] = [(65 - i) % 4, (65 - i + 1) % 4, (65 - i + 2) % 4, (65 - i + 3) % 4]
      case i
        when 1 .. 16
          f_a[i] = lambda {|x, y, z| (x & y) | ((~x) & z)}
          k_a[i] = i - 1
          s_a[i] = [7, 12, 17, 22][(i - 1) % 4]
        when 17 .. 32
          f_a[i] = lambda {|x, y, z| (x & z) | (y & (~z))}
          k_a[i] = (1 + (i - 17) * 5) % 16
          s_a[i] = [5, 9, 14, 20][(i - 1) % 4]
        when 33 .. 48
          f_a[i] = lambda {|x, y, z| x ^ y ^ z}
          k_a[i] = (5 + (i - 33) * 3) % 16
          s_a[i] = [4, 11, 16, 23][(i - 1) % 4]
        when 49 .. 64
          f_a[i] = lambda {|x, y, z| y ^ (x | (~z))}
          k_a[i] = ((i - 49) * 7) % 16
          s_a[i] = [6, 10, 15, 21][(i - 1) % 4]
      end
    end

    buf = str + ["10000000"].pack("B8")

    if (56 - buf.size % 64) < 0
      (64 + (56 - buf.size % 64)).times do
        buf += [0].pack("C")
      end
    else
      (56 - buf.size % 64).times do
        buf += [0].pack("C")
      end
    end

    buf += int64tobinstr_le(str.size * 8)

    m_a = []
    (buf.size / 64).times do |i|
      m_a[i] = buf[i * 64, 64]
    end

    abcd = []
    abcd = [a, b, c, d]
    abcd2 = []

    m_a.each do |m|
      x = []
      x = m.unpack("V16")
      abcd2 = abcd.dup

      (1..64).each do |n|
        abcd[n4_a[n][0]] = MASK & (abcd[n4_a[n][0]] + f_a[n].call(abcd[n4_a[n][1]], abcd[n4_a[n][2]], abcd[n4_a[n][3]]) + x[k_a[n]] + t_a[n])
        abcd[n4_a[n][0]] = rotate_left_shift_32bit(abcd[n4_a[n][0]], s_a[n])
        abcd[n4_a[n][0]] = MASK & (abcd[n4_a[n][0]] + abcd[n4_a[n][1]])
      end

      abcd.each_index do |i|
        abcd[i] = MASK & (abcd[i] + abcd2[i])
      end
    end
    return abcd2
  end

  def self.calc(secret)
    raise ArgumentError unless secret.is_a?(String)

    if secret.length > 64
      secret = Digest::MD5.digest(secret)
    end

    ki = str_xor(secret , 54)
    ko = str_xor(secret , 92)

    ci = hexdigest(ki)
    co = hexdigest(ko)

    innerhex = ci.pack("V4").unpack('H*')[0]
    outerhex = co.pack("V4").unpack('H*')[0]
    return "#{outerhex}#{innerhex}"
  end

end

