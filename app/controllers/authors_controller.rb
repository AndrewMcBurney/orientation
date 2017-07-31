class AuthorsController < ApplicationController
  respond_to :html

  def index
    ordered_users = User.order(:name).text_search(params[:search])
    authors = params[:all] ? ordered_users.all : ordered_users.active
    @authors = AuthorDecorator.decorate_collection authors

    respond_to do |format|
      format.html { render :index }
      format.js   { render :index, layout: false }
    end
  end

  def show
    @author = AuthorDecorator.decorate User.find(params[:id])
  end

  def update
    @author = User.find(params[:id])
    @author.update_attributes(author_params)
    if @author.save
      flash[:notice] = "You look nice today."
    else
      flash[:error] = "Uh, that didn't work!"
    end
    redirect_to author_path(@author)
  end

  def new
    @author = User.new
  end

  def create
    @author = User.new(author_params)
    if @author.save
      flash[:notice] = "Yay, one of us!"
      redirect_to author_path(@author)
    else
      flash[:error] = "That didn't work out so well."
      render :new
    end
  end

  def toggle_status
    @author = AuthorDecorator.decorate User.find(params[:author_id])
    @author.toggle!(:active)
    flash[:notice] = "This author is now #{@author.status}."
    redirect_to author_path(@author)
  end

  def toggle_email_privacy
    @author = User.find(params[:author_id])

    if current_user == @author
      @author.update(private_email: !@author.private_email)
      flash[:notice] = "Your email is now #{@author.email_status}."
    else
      flash[:notice] = "You can't change another user's email privacy settings."
    end

    redirect_to author_path(@author)
  end

  def destroy
    @author = User.find(params[:id])

    if !current_user.administrator?
      flash[:notice] = "You are not an administrator."
      redirect_to author_path(@author)
    elsif current_user == @author
      flash[:notice] = "You cannot delete yourself."
      redirect_to author_path(@author)
    else
      replacement_author = User.find(params[:replacement_author_id])
      @author.replace_and_destroy!(replacement_author)
      flash[:notice] = "You deleted #{@author.name} and re-assigned articles to #{replacement_author.name}."
      redirect_to authors_path
    end
  end

  private

  def author_params
    params.require(:user).permit(:name, :email, :shtick)
  end

end
