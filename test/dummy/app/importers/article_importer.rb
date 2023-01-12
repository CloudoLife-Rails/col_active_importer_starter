
# continuum/active_importer: Define importers that load tabular data from spreadsheets or CSV files into any ActiveRecord-like ORM.
# https://github.com/continuum/active_importer
class ArticleImporter < ColActiveImporterStarter::BaseImporter
  imports Article

  transactional
  module ColumnName
    Title = "Title"
    Body = "Body"
  end

  column ColumnName::Title, :title
  column ColumnName::Body, :body

  def handle_fetch_model
    params = {
      title: row[ColumnName::Title],
    }

    model = Article.find_or_initialize_by(params)

    model
  end

  fetch_model do
    handle_fetch_model
  end

  def handle_skip_rows_if?
    row[ColumnName::Title].blank?
  end

  skip_rows_if do
    handle_skip_rows_if?
  end

  # ArticleImporter.execute
  def self.execute(file = "#{Rails.root}/data/Articles.1.xlsx")
    params = {
      cache: {},
      file: file,
      result_index: 3,
    }
    import(file, params: params)
  end

  private
end
