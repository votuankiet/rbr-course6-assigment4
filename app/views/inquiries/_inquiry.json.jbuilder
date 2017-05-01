json.extract! inquiry, :id, :title, :description, :creator_id, :created_at, :updated_at
json.url inquiry_url(inquiry, format: :json)