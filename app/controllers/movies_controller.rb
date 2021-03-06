class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.uniq.pluck(:rating) # Retrieve the list of unique ratings inside the table movies
    @selected_ratings = []

    if params[:ratings]
      params[:ratings].each {|key, value| @selected_ratings << key}
      @movies = Movie.where(["rating IN (?)", @selected_ratings])
    elsif params[:sort]
      @movies = Movie.order(params[:sort])
      if params[:sort] == 'title'
        @css_title = 'hilite'
      elsif params[:sort] == 'release_date'
        @css_release_date = 'hilite'
      end
    else
      @movies = Movie.all
      @selected_ratings = Movie.uniq.pluck(:rating)
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
