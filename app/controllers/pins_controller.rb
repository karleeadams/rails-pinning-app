class PinsController < ApplicationController
	before_action :require_login, except: [:show, :show_by_name, :index]

  def index
    @pins = Pin.all(user: current_user)
  end
  
  def show
    
  end

  def show_by_name
  	@pin = Pin.find_by_slug!(params[:slug])
  	render :show
  end
  
  def new
  	@pin = Pin.new
  end

  def create
  	@pin = Pin.create(pin_params)
  	if @pin.valid?
  		@pin.save
  		redirect_to @pin
  	else
  		@errors = @pin.errors
  		render :new
  	end
  end

  def edit
  	@pin = Pin.find_by_id(params[:id])
  end

  def update
  	@pin = Pin.find(params[:id])
  	
  	if @pin.update(pin_params)
  		redirect_to @pin
  	else
  		@errors = @pin.errors
  		render :edit
  	end
  end

  private

  def pin_params
  	params.require(:pin).permit(:title, :url, :slug, :text, :category_id, :image, :user_id)
  end

end