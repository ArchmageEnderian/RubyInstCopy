module UsersHelper
  def display_avatar(user, options = {})
    if user.avatar.attached?
      image_tag(user.avatar, options)
    else
      image_tag('defaults/default_image.png', options)
    end
  end
end
