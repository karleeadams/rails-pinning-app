require "spec_helper"
Rspec.describe FollwersController do
	before(:each) do
		@user = FactoryGirl.create(:user_with_followees)
		@board = @user.boards.first
		login(@user)
	end
	after(:each) do
		if !@user.destroyed?
			Follower.where("follower_id=?", @user.id).first.destroy
			@user.destroy
		end
	end

	describe "GET index"

		it 'renders the index template' do
			get :index
			expect(response).to render_template(:index)
		end

		it 'populates @followed with all followed users' do
			get :index
			expect(assigns(:followers)).to eq(@user.followed)
		end

		it 'redirects to the login page if user is not logged in' do
			logout(@user)
			get :index
			expect(response).to redirect_to(:login)
		end

	end

	describe "GET new" do

		it 'responds with successfully' do
			get :new, users: @user.not_followed
			expect(response.success?).to eq(true)
		end

		it 'renders the new view' do
			get :new, users: @user.not_followed
			expect(response.success?).to eq(true)
		end

		it 'assigns an instance variable to a new pin' do
			get :new,users: @user.not_followed
			expect(assigns(:follower)).to be_a_new(follower)
		end

		it 'assigns @users to equal the users not followed by @user' do
			get :new, users: @user.not_followed
			expect(assigns(:users)).to eq(@user.not_followed)
		end

		it 'redirects to the login page if user is not logged in' do
			logout(@user)
			get :new, users: @user.not_followed
			expect(response).to redirect_to(:login)
		end
	end

	describe "POST create" do

		before(:each) do
			@follower_user = FactoryGirl.create(:user)
			@follower_hash = {
				user_id: @user.id,
				follower_id: @follower_user.id
			}
		end

		after(:each) do
			follower = Follower.where("user_id=? AND follower_id=?", @user.id, @follower_user.id)
			if !follower.empty?
				follower.destroy_all
				@follower_user.destroy
			end
		end

		it 'responds with a redirect' do
			post :create, follower: @follower_hash
			expect(response.redirect?).to eq(true)
		end

		it 'creates a follower' do
			post :create,  follower: @follower_hash
			expect(Follower.find_by(user_id: @user.id, follower_id: @follower_user.id).present?).to eq(true)
		end

		it 'redirects to the index view' do
			post :create, follower: @follower_hash
			expect(response).to redirect_to(followers_url)
		end

		it 'redirects to the login page if user is not logged in' do
			logout(@user)
			post :create, follower: @follower_hash
			expect(response).to redirect_to(:login)
		end
	end

end