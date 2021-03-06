ActiveAdmin.register Series do
  controller do
    with_role :admin

    def scoped_collection
      Series.includes(:user)
    end
  end

  index do 
    link_column :title
    column :user
    column :stories_count
    column :created_at
    column :updated_at
    edit_links
  end

  form do |f|
    f.inputs "Content" do 
      f.input :title
    end

    f.buttons
  end
end