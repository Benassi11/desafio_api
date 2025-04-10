class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :status_humanize, :estimated_time, :user_id , :attachments_urls

  belongs_to :user
  has_many :comments

  def attachments_urls
    object.attachments.map { |file| Rails.application.routes.url_helpers.rails_blob_url(file, only_path: true) }
  end

end