class TicketsController < ApplicationController
  before_action :authenticate_user!

  def new
    @ticket = Ticket.new
    @collection = Collection.find(params[:collection_id]) if params[:collection_id]
  end

  def create
    summary = params[:ticket][:summary]
    priority = params[:ticket][:priority]
    collection_id = params[:ticket][:collection_id]
    collection_name = Collection.find(collection_id).name if collection_id.present?
  
    # Construct the full URL
    link = url_for(controller: 'collections', action: 'show', id: collection_id, only_path: false)
  
    reporter_email = current_user.email
  
    # Initialize Jira client
    jira_client = JiraClient.new
  
    # Check if the reporter exists in Jira
    reporter_account_id = jira_client.get_account_id(reporter_email)
    
    # If reporter doesn't exist, create a Jira account
    if reporter_account_id.nil?
      jira_client.automate_sign_in_and_open_response_url(reporter_email)
      redirect_to collection_path(collection_id), alert: 'You have no Jira account. Please create account.'
      return
    end
  
    # Create Jira ticket
    jira_issue = jira_client.create_ticket(summary, priority, reporter_account_id, collection_name, link)
  
    if jira_issue
      # Save ticket in local database
      @ticket = current_user.tickets.build(
        summary: summary,
        priority: priority,
        jira_ticket_url: jira_issue[:url],
        status: jira_issue[:status],
        link: link  # Save the full URL in the ticket
      )
  
      if @ticket.save
        redirect_to user_profile_path(current_user), notice: 'Ticket created successfully.'
      else
        render :new
      end
    else
      Rails.logger.error("Failed to create Jira issue.")
      render :new, alert: 'Failed to create Jira issue.'
    end
  end
  
  
  
  def index
  end

  private

end
