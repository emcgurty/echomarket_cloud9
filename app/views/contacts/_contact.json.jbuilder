json.extract! contact, :id, :contact_id, :user_id, :subject, :email, :comments, :remote_ip, :created_at, :updated_at
json.url contact_url(contact, format: :json)
