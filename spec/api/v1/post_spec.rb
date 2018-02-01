require 'rails_helper'

describe 'Profile API', type: :request do
  let!(:user) { create(:user) }
  let!(:posts) { create_list(:post, 3, user: user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /posts' do
    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        get '/api/v1/posts', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is invalid access_token' do
        get '/api/v1/posts', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      before { get '/api/v1/posts', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 if there is valid access_token' do
        expect(response.status).to eq 200
      end

      it 'returns all posts' do
        expect(response.body).to be_json_eql(posts.to_json)
      end

      %w(id user_id text).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(posts.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w(created_at updated_at).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not be_json_eql(posts.first.send(attr.to_sym).to_json)
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'unauthorized' do
      it 'returns 401 if there is no access_token' do
        post '/api/v1/posts', params: { format: :json }#, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is invalid access_token' do
        post '/api/v1/posts', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end

      it 'does not create post with invalid params' do
        expect { post '/api/v1/posts', params: { post: attributes_for(:invalid_post), format: :json } }.to_not change(Post, :count)
      end

      it 'returns 401 if invalid params' do
        post '/api/v1/posts', params: { post: attributes_for(:invalid_post), format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      it 'returns 201 if there is valid access_token' do
        post '/api/v1/posts', params: { post: attributes_for(:post), access_token: access_token.token, format: :json }
        expect(response.status).to eq 201
      end

      it 'creates new post' do
        expect { post '/api/v1/posts', params: { post: attributes_for(:post), access_token: access_token.token, format: :json } }.
          to change(Post, :count).by(1)
      end
    end
  end
end
