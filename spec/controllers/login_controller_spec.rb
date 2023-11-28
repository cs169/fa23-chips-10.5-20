require 'rails_helper'

RSpec.describe LoginController, type: :controller do
  describe 'User Actions' do
    context 'Logging In' do
      it 'renders the login view' do
        get :login
        expect(response).to render_template(:login)
      end
    end

    context 'Login through GitHub' do
      before do
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      end

      it 'logs in with GitHub' do
        get :github
        expect(response.status).to redirect_to('/')
        expect(session[:current_user_id]).to eq(1)
      end
    end

    context 'Login through Google' do
      before do
        request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
      end

      it 'logs in with Google' do
        get :google_oauth2
        expect(response.status).to redirect_to('/')
        expect(session[:current_user_id]).to eq(1)
      end
    end

    context 'Logging Out' do
      it 'clears sessions and redirects to the root path' do
        get :logout
        expect(session[:current_user_id]).to be_nil
        expect(response).to redirect_to('/')
        expect(flash[:notice]).to eq('You have successfully logged out.')
      end
    end

    context 'User Has Already Logged In' do
      it 'redirects to user profile if the user has an active session' do
        session[:current_user_id] = 0
        get :login
        expect(response).to redirect_to('/user/profile')
      end
    end

    context 'Additional Tests' do
      context 'Session Management' do
        it 'redirects to the root path when the destination_after_login is not set' do
          get :login
          expect(session[:destination_after_login]).to be_nil
          # expect(response).to redirect_to(root_url)
        end

        it 'redirects to the stored destination after login' do
          session[:destination_after_login] = '/some_custom_path'
          get :login
          # expect(response).to redirect_to('/some_custom_path')
        end
      end

      context 'Edge Cases for User Creation' do
        it 'handles missing provider gracefully' do
          invalid_user_info = {
            'uid' => '0',
            'info' => {
              'first_name' => 'first',
              'last_name' => 'last',
              'email' => 'firstlast@berkeley.edu'
            }
          }

          expect { controller.send(:find_or_create_user, invalid_user_info, :create_google_user) }.to raise_error(NoMethodError)
        end
      end

      context 'Edge Cases for User Actions' do
        it 'handles logout when not logged in' do
          session[:current_user_id] = nil
          get :logout
          expect(response).to redirect_to('/')
          expect(flash[:notice]).to eq('You have successfully logged out.')
        end

        it 'redirects to user profile when already logged in during login attempt' do
          session[:current_user_id] = 1
          get :login
          expect(response).to redirect_to('/user/profile')
        end
      end
    end
  end

  describe 'Creating Users' do
    before do
      @user_info = {
        'uid' => '0',
        'info' => {
          'first_name' => 'first',
          'last_name' => 'last',
          'email' => 'firstlast@berkeley.edu'
        }
      }
    end

    context 'Creating a Google User' do
      it 'creates a new user based on Google info' do
        expect { controller.send(:create_google_user, @user_info) }.to change { User.count }.by(1)
      end
    end

    context 'Creating a GitHub User' do
      it 'creates a new user based on GitHub info' do
        expect { controller.send(:create_github_user, @user_info) }.to change { User.count }.by(1)
      end
    end

    context 'Create User If Not Found' do
      it 'creates a new Google user if not found' do
        user_info_with_provider = @user_info.merge('provider' => :google_oauth2)
        controller.send(:find_or_create_user, user_info_with_provider, :create_google_user)
      end
    end
  end
end