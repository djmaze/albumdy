class ZipArchivesController < ResourceController::Base
  before_filter :login_required, :only => [:new, :edit, :update]
  before_filter :load_album

  create.before { object.album = @album }    

  # redirect to the user album instead of show on update and destroy
  [update, destroy, create].each do |action| 
    action.wants.html { redirect_to edit_photos_user_album_path(current_user, @album) }
  end

  private
    def load_album
      @album = current_user.albums.find(params[:album_id])
    end  

end
