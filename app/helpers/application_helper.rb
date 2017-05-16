module ApplicationHelper
  def full_title title
    base="SocialReader"
    title.present? ? base + " | " + title : base
  end

  def type_label_color type
    case type
      when "camera"
        "orange"
      when "design"
        "blue"
      when "general"
        "red"
      when "misc"
        "black"
      when "perform"
        "teal"
      when "unclassified"
        "white"
    end
  end
end
