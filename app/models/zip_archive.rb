class ZipArchive
  attr_accessor :album
  
  def initialize(attributes={})
    @zip_file = attributes[:zip_file] if attributes
  end  

  def save
    zip_path = File.join(Dir::tmpdir, @zip_file.original_filename)
    
    # Copy zip to temp dir
    FileUtils.copy(@zip_file.local_path, zip_path)
    
    # Iterate through zip contents
    Zip::ZipFile.foreach(zip_path) do |file|
      # TODO Tempfile would be better, but doesn't give correct mime type!
      tmpfile_path = File.join(Dir.tmpdir, file.name)

      # Write image to temp file
      tmpfile = File.new(tmpfile_path, 'w+')
      tmpfile.write file.get_input_stream.read

      # Rewind temp file and create photo record from image
      tmpfile.rewind
      @album.photos.create!(:image => tmpfile, :title => File.basename(file.name, File.extname(file.name)))

      # Close and delete temp file
      tmpfile.close
      File::unlink(tmpfile_path)
    end    
    
    # Remove temporary zip fle
    File::unlink(zip_path)
  end

  def errors
    # TODO
    []
  end  
  
end