json.extract! user, :id, :user_id, :username, :community_name, :email, :date_created, :date_updated, :remote_id, :crypted_password, :salt, :reset_code, :activated_at, :user_alias, :user_type, :role_id, :created_at, :updated_at
json.url user_url(user, format: :json)
