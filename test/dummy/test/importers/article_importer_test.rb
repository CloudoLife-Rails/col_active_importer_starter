require "test_helper"

class ArticleImporterTest < ActiveSupport::TestCase
  test "execute" do
    ArticleImporter.execute
    articles = Article.all
    assert_equal(2, articles.length, "1111")
  end
end
