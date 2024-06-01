require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  render_views
  describe 'GET #search' do
    it 'returns http success' do
      get :search
      expect(response).to have_http_status(:success)
    end

    context 'when search query is present' do
      let(:user) { create(:user) }
      let(:collection) { create(:collection, name: 'Test Collection', description: 'Description', topic: 'Test Topic', user: user) }
      let(:item) { create(:item, name: 'Test Item', description: 'Description', tags: ['tag1', 'tag2'], collection: collection) }
      let(:comment) { create(:comment, content: 'Comment content', item: item) }
      let(:custom_field) { create(:custom_field, collection: collection) } # Assuming you have a factory for custom fields
      let(:custom_field_value) { create(:item_custom_field_value, value: 'Custom value', item: item, custom_field: custom_field) }

      before do
        collection
        item
        comment
        custom_field
        custom_field_value
      end

      it 'returns search results' do
        get :search, params: { query: 'Test' }
        expect(response).to have_http_status(:success)
        expect(assigns(:search_results)[:collections]).to include(collection)
        expect(assigns(:search_results)[:items]).to include(item)
      end
    end

    context 'when search query is not present' do
      it 'does not return search results' do
        get :search
        expect(response).to have_http_status(:success)
        expect(assigns(:search_results)).to be_nil
      end
    end
  end
end
