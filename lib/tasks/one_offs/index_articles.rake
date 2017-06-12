desc "Create index for Article model"
task index_articles: :environment do
  Article.reindex
end
