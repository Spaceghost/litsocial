ActiveAdmin.register Comment, :as => "UserComment" do
  
  actions :index, :show, :edit, :update
  
  form do |f|
    f.inputs do
      f.input :contents, :as => :html, :hint => "<br/>Do not edit a user's comment without a damn good reason.".html_safe
      f.input :deleted
      f.input :deleted_reason
    end
    f.buttons
  end
  
  # index do
  #   column :id
  #   column :name do |u|
  #     link_to u.name, admin_user_path(u)
  #   end
  #   column :gender
  #   column :current_sign_in_at
  #   column "FB Profile" do |u|
  #     if u.linked_to_facebook?
  #       link_to u.facebook_name, u.facebook_profile
  #     else
  #       em "No"
  #     end
  #   end
  #   column "TZ", :timezone
  #   column :admin do |u| u.admin? ? "Yes" : "No" end
  #   
  #   column do |f|
  #     link_to("Edit", [:edit, :admin, f], :class => "member_link")
  #   end
  # end
  
  
  before_save do |currm|
    currm.assign_attributes(params[:comment], :role => :admin)
  end
end
