class SearchController < ApplicationController
  def search
    if params[:query].present?
      search_term = params[:query]

      # Search for items directly, including tags
      item_results = Item.where("name ILIKE ? OR description ILIKE ? OR tags::text ILIKE ?", 
                                "%#{search_term}%", "%#{search_term}%", "%#{search_term}%").pluck(:id)

      # Search for items through comments
      comment_results = Comment.where("content ILIKE ?", "%#{search_term}%").pluck(:item_id)

      # Search for items through custom field values
      custom_field_results = ItemCustomFieldValue.where("value ILIKE ?", "%#{search_term}%").pluck(:item_id)

      # Combine all item IDs and remove duplicates
      all_item_ids = (item_results + comment_results + custom_field_results).uniq

      # Fetch unique items based on the combined item IDs
      @items = Item.includes(:collection).where(id: all_item_ids)

      # Search for collections including topic
      @collections = Collection.includes(:user)
                               .where("name ILIKE ? OR description ILIKE ? OR topic ILIKE ?", 
                                      "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")

      # Combine search results
      @search_results = {
        collections: @collections,
        items: @items
      }
    end
  end
end
