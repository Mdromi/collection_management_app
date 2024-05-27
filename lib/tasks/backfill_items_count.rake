namespace :backfill do
  desc "Backfill items_count for collections"
  task items_count: :environment do
    Collection.find_each do |collection|
      Collection.reset_counters(collection.id, :items)
    end
  end
end

# rails backfill:items_count