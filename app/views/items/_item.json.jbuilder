json.extract! item, :id, :item_id, :participant_id, :category_id, :other_item_category, :item_model, :item_description, :item_condition_id, :item_count, :comment, :created_at, :updated_at, :date_deleted, :approved, :notify, :item_type, :remote_ip, :created_at, :updated_at
json.url item_url(item, format: :json)
