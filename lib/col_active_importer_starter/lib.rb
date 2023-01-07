
# continuum/active_importer: Define importers that load tabular data from spreadsheets or CSV files into any ActiveRecord-like ORM.
# https://github.com/continuum/active_importer
module ColActiveImporterStarter
  module ColumnName
    Code = "Code"

    Name = "Name"
    Seq = 'Seq'

    ParentCode = "Parent Code"
  end

  module ResultIndex
    ID = :result_index
  end

  module ResultColumnName
    ID = 'Result ID'
    Message = 'Result Message'
    Error = 'Result Error'
  end

  module ResultValue
    Success = 'success'
    Fail = 'fail'
    Skip = 'skip'
  end

  def self.handle_model_cache!(cache, key)
    model = cache[key]
    return model if model.present?

    Rails.logger.info("Cache not found: #{key}")
    model = yield(key) if block_given?

    cache[key] = model

    model
  end

  class BaseImporter < ActiveImporter::Base

    def get_result_id_column_index
      params[ResultIndex::ID]
    end

    def initialize_result_exporter
      exporter = RubyXL::Parser.parse(params[:file])
      exporter_sheet1 = exporter[0]

      header_index = @header_index - 1
      column_index = get_result_id_column_index
      exporter_sheet1.add_cell(header_index, (column_index += 1), ResultColumnName::ID)
      exporter_sheet1.add_cell(header_index, (column_index += 1), ResultColumnName::Message)

      @exporter = exporter
      @exporter_sheet1 = exporter_sheet1
    end

    def initialize_model_cache
      model_cache = params.try(:[], :model_cache) || {}

      @model_cache = model_cache
    end

    on :import_started do
      initialize_result_exporter
      initialize_model_cache
    end

    # on :row_skipped do
    #   sheet1 = @sheet1
    #
    #   row_index = @row_index - @header_index
    #   column_index = ColumnIndex::Imported
    #   column_index += 1
    #   sheet1[row_index, (column_index += 1)] = ResultColumnName::Skip
    # end

    def handle_row_success
      exporter_sheet1 = @exporter_sheet1

      row_index = @row_index - @header_index
      column_index = get_result_id_column_index
      column_index += 1
      exporter_sheet1.add_cell(row_index, (column_index += 1), ResultValue::Success)
    end

    on :row_success do
      handle_row_success
    end

    def handle_row_error(e)
      exporter_sheet1 = @exporter_sheet1

      row_index = @row_index - @header_index
      column_index = get_result_id_column_index
      column_index += 1
      exporter_sheet1.add_cell(row_index, (column_index += 1), ResultValue::Fail)
      exporter_sheet1.add_cell(row_index, (column_index += 1), e.message)
    end

    on :row_error do |e|
      handle_row_error(e)
    end

    def handle_row_processed
      exporter_sheet1 = @exporter_sheet1

      row_index = @row_index - @header_index
      column_index = get_result_id_column_index
      exporter_sheet1.add_cell(row_index, (column_index += 1), model&.id)
    end

    on :row_processed do
      handle_row_processed
    end


    def handle_import_finished
      exporter = @exporter

      file = params[:file]

      extname = '.xlsx'
      if file.present?
        extname = File.extname(file)
        basename = File.basename(file, extname)
      end

      result_file = "tmp/Result-#{Time.now.strftime('%Y%m%d%H%M%S')}-#{basename}#{extname}"

      exporter.write result_file
    end

    on :import_finished do
      handle_import_finished
    end
  end
end