class AddLinkToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :link, :string
  end
end
