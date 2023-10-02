=begin
class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def build_resource(*args)
    super
    if resource.persisted?
      resource.username ||= "User#{resource.id}"
      resource.avatar ||= 'app/assets/images/defaults/default_image.png'
      resource.save
    end
  end

  def after_sign_up_path_for(resource)
    edit_user_path(@user)
  end
end=end
