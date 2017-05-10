module ApplicationHelper
  def full_title title
    base="SocialReader"
    title.present? ? base + " | " + title : base
  end

end
