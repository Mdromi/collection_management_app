class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :summary
      t.string :priority
      t.string :jira_ticket_url
      t.string :status

      t.timestamps
    end
  end
end
