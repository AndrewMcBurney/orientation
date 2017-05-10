class SendArticleOutdatedJob < ApplicationJob
  queue_as :default

  def perform(article_id, reporter_id, description)
    article = Article.includes(:editor, :author).find(article_id)
    contributors = article.contributors
    reporter = User.find(reporter_id)

    ArticleMailer.send_outdated_notification_for(article, contributors, reporter, description).deliver
  end
end
