class UpdateRequest < ActiveRecord::Base
  belongs_to :article
  belongs_to :reporter, class_name: "User"

  after_create :outdated_article

  private

  def outdated_article
    article.outdated!(reporter_id, description)
  end
end
