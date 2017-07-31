desc "Reindex Article models for algoliasearch"
namespace :algolia do
  task reindex: :environment do
    Article.reindex
    User.reindex
  end
end
