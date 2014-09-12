json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :url, :file_size, :content_type
  json.url attachment_url(attachment, format: :json)
end
