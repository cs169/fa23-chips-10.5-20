require 'rails_helper'

RSpec.describe MyEventsController, type: :controller do
  let!(:user) { User.create!(provider: 1, uid: '123456789', email: 'leahwang61@berkeley.edu', first_name: 'Leah', last_name: 'Wang') }
  let!(:state) { State.create!(name: 'Texas', symbol: 'TX', fips_code: 48, is_territory: 0, lat_min: 25.84, lat_max: 36.5, long_min: -106.65, long_max: -93.51) }
  let!(:county) { County.create!(name: 'Travis', state: state, fips_code: 1, fips_class: 'H1') }

  let(:valid_attributes) do
    {
      name: 'Community Art Festival',
      description: 'Art and Culture',
      start_time: '2120-05-15',
      end_time: '2120-05-16',
      county_id: county.id
    }
  end

  let(:invalid_attributes) { { name: '', county_id: nil } }

  describe 'GET #new' do
    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      it 'assigns a new event as @event' do
        get :new
        expect(assigns(:event)).to be_a_new(Event)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'GET #edit' do
    let!(:event) { Event.create!(valid_attributes) }

    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      it 'assigns the requested event as @event' do
        get :edit, params: { id: event.id }
        expect(assigns(:event)).to eq(event)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        get :edit, params: { id: event.id }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      context 'with valid params' do
        it 'creates a new Event' do
          expect {
            post :create, params: { event: valid_attributes }
          }.to change(Event, :count).by(1)
        end

        it 'redirects to the events list' do
          post :create, params: { event: valid_attributes }
          expect(response).to redirect_to(events_path)
        end
      end

      context 'with invalid params' do
        it 'does not create a new Event' do
          expect {
            post :create, params: { event: invalid_attributes }
          }.not_to change(Event, :count)
        end

        it 're-renders the "new" template' do
          post :create, params: { event: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post :create, params: { event: valid_attributes }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'PUT #update' do
    let!(:event) { Event.create!(valid_attributes) }

    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      context 'with valid params' do
        let(:new_attributes) { { name: 'New Event Name' } }

        it 'updates the requested event' do
          put :update, params: { id: event.id, event: new_attributes }
          event.reload
          expect(event.name).to eq('New Event Name')
        end

        it 'redirects to the event list' do
          put :update, params: { id: event.id, event: new_attributes }
          expect(response).to redirect_to(events_path)
        end
      end

      context 'with invalid params' do
        it 'does not update the event' do
          put :update, params: { id: event.id, event: invalid_attributes }
          event.reload
          expect(event.name).not_to eq('')
        end

        it 're-renders the "edit" template' do
          put :update, params: { id: event.id, event: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        put :update, params: { id: event.id, event: valid_attributes }
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:event) { Event.create!(valid_attributes) }

    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      it 'destroys the requested event' do
        expect {
          delete :destroy, params: { id: event.id }
        }.to change(Event, :count).by(-1)
      end

      it 'redirects to the events list' do
        delete :destroy, params: { id: event.id }
        expect(response).to redirect_to(events_url)
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        delete :destroy, params: { id: event.id }
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
