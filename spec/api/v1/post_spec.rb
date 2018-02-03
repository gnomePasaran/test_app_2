require 'rails_helper'

describe 'Profile API', type: :request do
  let!(:user) { create(:user) }
  let!(:posts) { create_list(:post, 3, user: user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:full_posts) { posts.map { |post| { likes: post.likes.count, text: post.text, user_id: post.user_id } } }

  describe 'GET /posts' do
    context 'when unauthorized' do
      it 'returns 401 if there is no access_token' do
        get '/api/v1/posts', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is invalid access_token' do
        get '/api/v1/posts', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      before { get '/api/v1/posts', params: { access_token: access_token.token, format: :json } }

      it 'returns 200 if there is valid access_token' do
        expect(response.status).to eq 200
      end

      it 'returns all posts' do
        expect(response.body).to be_json_eql(full_posts.to_json)
      end

      %w[id user_id text].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(posts.first.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'contains likes' do
        expect(response.body).to be_json_eql(posts.first.likes.count.to_json).at_path('0/likes')
      end

      %w[created_at updated_at].each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).not_to be_json_eql(posts.first.send(attr.to_sym).to_json)
        end
      end
    end
  end

  describe 'POST /create' do
    let!(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'when unauthorized' do
      it 'returns 401 if there is no access_token' do
        post '/api/v1/posts', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is invalid access_token' do
        post '/api/v1/posts', params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      it 'does not create post with invalid params' do
        expect do
          post '/api/v1/posts', params: {
            post: attributes_for(:invalid_post), access_token: access_token.token, format: :json
          }
        end
          .not_to change(Post, :count)
      end

      it 'returns 422 if invalid params' do
        post '/api/v1/posts',
             params: { post: attributes_for(:invalid_post), access_token: access_token.token, format: :json }
        expect(response.status).to eq 422
      end

      it 'returns 201 if there is valid access_token' do
        post '/api/v1/posts', params: { post: attributes_for(:post), access_token: access_token.token, format: :json }
        expect(response.status).to eq 201
      end

      it 'creates new post' do
        expect { post '/api/v1/posts', params: { post: attributes_for(:post), access_token: access_token.token, format: :json } }
          .to change(Post, :count).by(1)
      end
    end
  end

  describe 'POST /like' do
    let!(:user) { create(:user) }
    let!(:post_for_like) { create(:post) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let!(:post_not_for_like) { create(:post, user: user) }

    context 'when unauthorized' do
      it 'returns 401 if there is no access_token' do
        post like_api_v1_post_path(post_for_like.id), params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 if there is invalid access_token' do
        post like_api_v1_post_path(post_for_like.id), params: { format: :json, access_token: '123' }
        expect(response.status).to eq 401
      end
    end

    context 'when authorized' do
      it 'returns 201 if there is valid access_token' do
        post like_api_v1_post_path(post_for_like.id), params: {
          post_id: post_for_like.id, access_token: access_token.token, format: :json
        }
        expect(response.status).to eq 201
      end

      it 'creates new post' do
        expect do
          post like_api_v1_post_path(post_for_like.id), params: {
            post_id: post_for_like.id, access_token: access_token.token, format: :json
          }
        end
          .to change(post_for_like.likes, :count).by(1)
      end

      it 'does not like own posts' do
        expect do
          post like_api_v1_post_path(post_not_for_like.id), params: {
            post_id: post_not_for_like.id, access_token: access_token.token, format: :json
          }
        end
          .not_to change(post_not_for_like.likes, :count)
      end
    end
  end
end
