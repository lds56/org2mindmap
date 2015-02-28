require 'stringio'
# load DATA at any Ruby file
# provided by James A. Rosen and glenn jackman's answers
module DataLoader
  def self.from(filename)
    data = StringIO.new
    File.open(filename) do |f|
      begin
        line = f.gets
      end until line.match(/^__END__$/)
      while line = f.gets
        data << line
      end
    end
    data.rewind
    data
  end
end