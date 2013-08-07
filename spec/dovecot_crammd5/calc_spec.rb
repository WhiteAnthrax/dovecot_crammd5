require 'spec_helper'

describe DovecotCrammd5 do
  describe 'pattern normal' do
    it 'returns cram-md5 hash when strings passed.' do
      expect(DovecotCrammd5.calc('hogehoge')).to eql 'dcbe8064d829ee98ad16817611150a6c7ee5fe1c9dfd79f5395be892f162bfd3'
    end

    it 'returns cram-md5 hash when string and numbers passed.' do
      expect(DovecotCrammd5.calc('knight2000')).to eql '527435f1729f9f52e1ff10ce6e72a6a26a43e2937823849d83500c6c55690565'
    end

    it 'returns cram-md5 hash when upcase and downcase strings passed.' do
      expect(DovecotCrammd5.calc('HOGEhoge')).to eql '764cc43ce35fced4614805835d5925f5254505fba878adb050403cefcb1e70d8'
    end

    it 'returns cram-md5 hash when long strings(100) passed' do
      expect(DovecotCrammd5.calc('a'*100)).to eql 'f468fcff219b517f6814f5fefa4e894aa8abc2884f2718fa15e07f4cda81f854'
    end

    it 'returns cram-md5 hash when none alphabetical charactors' do
      expect(DovecotCrammd5.calc('!@#$%^&*()')).to eql '75a21ee215b3ca9a9efdbe712076324414c7388a6a04bedcfdc47c852fd67b25'
    end
  end

  describe 'pattern abnormal' do
    describe 'case none String' do
      it 'raise expection when nil passed.' do
        expect{DovecotCrammd5.calc(nil)}.to raise_error(ArgumentError)
      end

      it 'raise expection when Fixnum passed.' do
        expect{DovecotCrammd5.calc(1)}.to raise_error(ArgumentError)
      end

      it 'raise expection when Array passed.' do
        expect{DovecotCrammd5.calc([])}.to raise_error(ArgumentError)
      end

      it 'raise expection when Hash passed.' do
        expect{DovecotCrammd5.calc({})}.to raise_error(ArgumentError)
      end
    end
  end
end
