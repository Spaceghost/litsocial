class LiteraturesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :find_literature, :except => [:index, :new, :create]
  before_filter :new_literature, :only => [:new, :create]
  before_filter :check_permissions, :only => [:edit, :update, :destroy]
  
  def index
    @literatures = paged(Literature.includes(:user))
  end
  
  def show
    return show403 "This post has been removed by the author, sorry. :(" unless @literature.visible? || @literature.user == current_user
    @comments = paged(@literature.comments.top_levels.includes(:user, {:children => :user}))
  end
  
  def new
  end
  
  def create
    if @literature.save
      redirect @literature
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @literature.update_attributes(params[:literature])
      redirect @literature
    else
      render :edit
    end
  end
  
  def destroy
    show403 "Deleting posts isn't supported yet. It should be added soon."
  end
  
  protected
  def find_literature
    @literature = Literature.find(params[:id])
  end
  
  def new_literature
    @literature = current_user.literatures.new(params[:literature])
  end
  
  def check_permissions
    show403 "I'm sorry, I can't let you edit this post because it doesn't belong to you." if @literature.user != current_user
  end
end