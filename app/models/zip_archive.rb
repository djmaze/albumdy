class ZipArchive
  attr_accessor :album
  
  def initialize(attributes={})
    @zip_file = attributes[:zip_file] if attributes
  end  

  def save
    Zip::ZipFile.open(@zip_file.local_path) do |zipfile|
      zipfile.dir.foreach('.') do |file|
        # TODO Tempfile would be better, but doesn't give correct mime type!
        tmpfile = File.new("/tmp/#{file}", 'w+')
        tmpfile.write zipfile.file.read(file)

        tmpfile.rewind
        @album.photos.create!(:image => tmpfile, :title => File.basename(file, File.extname(file)))

        tmpfile.close
        File::unlink("/tmp/#{file}")
     end
    end
  end

  def errors
    # TODO
    []
  end  
  
end