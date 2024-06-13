require 'jira-ruby'
require 'uri'
require 'launchy'

class JiraClient
  def initialize
    @client = initialize_jira_client
  end

  def get_account_id(email)
    raise "Email cannot be nil" if email.nil?
  
    # Encode the full email for the query
    encoded_query = URI.encode_www_form_component(email)
    response = @client.get("/rest/api/3/user/search?query=#{encoded_query}")
  
    users = JSON.parse(response.body)
  
    if users.empty?
      # Retry with a more generic query
      puts "No users found. Retrying with a more generic query."
      query = email.split('@').first
      encoded_query = URI.encode_www_form_component(query)
      response = @client.get("/rest/api/3/user/search?query=#{encoded_query}")
  
      users = JSON.parse(response.body)
    end
  
    # Find the user whose email matches exactly
    user = users.first

    # If user is found, return the accountId, else return nil
    if user
      user['accountId']
    else
      nil
    end
  end

  def create_ticket(summary, priority, reporter_account_id, collection_name, link)
    return false if reporter_account_id.nil?
  
    # Retrieve priorities from Jira
    priorities = fetch_priorities
  
    # Find priority ID for the given priority name
    priority_id = find_priority_id(priorities, priority)
    return false unless priority_id

    # Build issue data to create a new issue in Jira
    issue_data = build_issue_data(summary, collection_name, link, priority_id, reporter_account_id)
  
    begin
      # Save the issue in Jira
      issue = save_issue(issue_data)
  
      # Construct Jira issue view URL
      issue_view_url = construct_issue_view_url(issue)
      
      # Transition issue to "In Progress"
      transition_to_in_progress(issue)
  
      # Fetch updated issue to get the current status
      issue.fetch
  
      # Get the current status name
      status_name = fetch_status_name(issue)

      return { url: issue_view_url, status: status_name }
    rescue JIRA::HTTPError => e
      # Log error details for debugging
      Rails.logger.error("Jira issue creation failed: #{e.message}")
      Rails.logger.error("Request data: #{issue_data}")
      return false
    end
  end

  def automate_sign_in_and_open_response_url(email)
    sign_up_url = "https://id.atlassian.com/signup?continue=https%3A%2F%2Fadmin.atlassian.com%2F%3Fare%3Daid&email=#{email}"
    # Open the response URL externally
    Launchy.open(sign_up_url)
  end

  private

  def initialize_jira_client
    options = {
      username: ENV['JIRA_USERNAME'],
      password: ENV['JIRA_API_TOKEN'],
      site: ENV['JIRA_SITE'],
      context_path: '',
      auth_type: :basic,
      read_timeout: 120
    }

    JIRA::Client.new(options)
  end

  def fetch_priorities
    response = @client.get('/rest/api/3/priority')
    JSON.parse(response.body)
  end

  def find_priority_id(priorities, priority_name)
    priority_hash = priorities.find { |p| p['name'] == priority_name }
    if priority_hash.nil?
      Rails.logger.error("Priority not found: #{priority_name}")
      return nil
    end
    priority_hash['id']
  end

  def build_issue_data(summary, collection_name, link, priority_id, reporter_account_id)
    {
      'fields' => {
        'project' => { 'key' => 'CMS2' },
        'summary' => summary,
        'description' => "Collection: #{collection_name}\nLink: #{link}",
        'issuetype' => { 'name' => 'Task' },
        'priority' => { 'id' => priority_id },
        'reporter' => { 'id' => reporter_account_id }
      }
    }
  end

  def save_issue(issue_data)
    issue = @client.Issue.build
    issue.save(issue_data)
    issue
  end

  def construct_issue_view_url(issue)
    jira_base_url = ENV['JIRA_SITE']
    "#{jira_base_url}/browse/#{issue.key}"
  end

  def transition_to_in_progress(issue)
    transition_id = get_transition_id(issue, "In Progress")
    if transition_id
      @client.post("/rest/api/3/issue/#{issue.key}/transitions", {
        'transition' => { 'id' => transition_id }
      }.to_json, { 'Content-Type' => 'application/json' })
    else
      Rails.logger.error("Transition to 'In Progress' not found.")
    end
  end

  def get_transition_id(issue, transition_name)
    transitions = @client.get("/rest/api/3/issue/#{issue.key}/transitions").body
    JSON.parse(transitions)['transitions'].find { |t| t['name'] == transition_name }['id']
  rescue
    nil
  end

  def fetch_status_name(issue)
    issue.fields['status']['name']
  end
end
