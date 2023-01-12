require "test_helper"

class ArticleImporterTest < ActiveSupport::TestCase
  test "import" do
    file = "#{Rails.root}/data/Articles.1.xlsx"

    importer = ArticleImporter.import(file)
    articles = Article.all
    assert_equal(2, articles.length, "articles.length not equal 2")
  end

  test "execute" do
    importer = ArticleImporter.execute
    articles = Article.all
    assert_equal(2, articles.length, "articles.length not equal 2")
  end

  test "get importer" do
    file = "#{Rails.root}/data/Articles.1.xlsx"

    importer = ArticleImporter.new(file, {params: params(file)})
    importer.import

    count = 2

    assert_equal(count, importer.row_count, "importer.row_count not equal #{count}")
    assert_equal(count, importer.row_processed_count, "importer.row_processed_count not equal #{count}")
    assert_equal(count, importer.row_success_count, "importer.row_success_count not equal #{count}")
    assert_equal(0, importer.row_error_count, "importer.row_error_count not equal 0")
  end

  private

  def params(file)
    params = {
      cache: {},
      file: file,
      result_index: 3,
    }
  end
end
