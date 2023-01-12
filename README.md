# col_active_importer_starter

col_active_importer_starter is a starter(or wrapper) to [active_importer - https://github.com/continuum/active_importer](https://github.com/continuum/active_importer) gem.

## Features

`col_active_importer_starter` makes full use of `active_importer` gem to import tabular data from spreadsheets or similar sources into Active Record models.

- The best practices of `active_importer`, such as:
  - [Custom parameters · continuum/active_importer Wiki - https://github.com/continuum/active_importer/wiki/Custom-parameters](https://github.com/continuum/active_importer/wiki/Custom-parameters)
  - [Events and callbacks - https://github.com/continuum/active_importer/wiki/Callbacks](https://github.com/continuum/active_importer/wiki/Callbacks).
- Introduce a optional cache to retain data in the memory
- Use rubyXL to write out a file with the original data and more information for result

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'col_active_importer_starter'
```

And then execute:

```shell
bundle
```

Or install it yourself as:

```shell
gem install col_active_importer_starter
```

## Usages

Suppose there is a ActiveRecord model `Article`:

```ruby
class Article < ApplicationRecord

end
```
and tabular data file `data/Articles.xlsx`

| Title           | Body            |
|-----------------|-----------------|
| Article.1.title | Article.1.body  |
| Article.2.title | Article.2.body  |

1. Create a `ArticleImporter` extend `ColActiveImporterStarter::BaseImporter`

```ruby
# app/importers/article_import.rb

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
      result_index: 10,
    }
    import(file, params: params)
  end

  private
end
```

2. Import data from a file.

```ruby
ArticleImporter.import("#{Rails.root}/data/Articles.1.xlsx")

# Or use ArticleImporter instance.
# importer = ArticleImporter.new(file, {params: params(file)})
# importer.import
# puts importer.row_count
```

Or specify more arguments.

```ruby
params = {
  cache: {},
  file: "#{Rails.root}/data/Articles.1.xlsx",
  result_index: 3,
}

ArticleImporter.import(file, {params: params})

# Or use ArticleImporter instance.
# importer = ArticleImporter.new(file, {params: params(file)})
# importer.import
# puts importer.row_count
```

For more examples to see [./test/dummy/test/importers/article_importer_test.rb](./test/dummy/test/importers/article_importer_test.rb).

3. Then, check `tmp/importers` directory to find the result file.

| Title           | Body            |   | Result ID | Result Message  |
|-----------------|-----------------|---|-----------|-----------------|
| Article.1.title | Article.1.body  |   | 1         | success         |
| Article.2.title | Article.2.body  |   | 2         | success         |

## Testing

Run `rails test` to execute all test cases in `test/dummy/test` directory.

```shell
rails test test/dummy/test
```

## Inspire

Inspire by [active_importer - https://github.com/continuum/active_importer](https://github.com/continuum/active_importer).

## Contributing

Contributions are welcome! Take a look at our contributions guide for details.
The basic workflow for contributing is the following:

- [Fork it - https://github.com/CloudoLife/col_active_importer_starter/fork](https://github.com/CloudoLife/col_active_importer_starter/fork)
- Create your feature branch (git checkout -b my-new-feature)
- Commit your changes (git commit -am 'Add some feature')
- Push to the branch (git push origin my-new-feature)
- Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License - https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).

## References

[1] [CloudoLife-Rails/col_active_importer_starter: col_active_importer_starter is a starter(or wrapper) to [active_importer. - https://github.com/CloudoLife-Rails/col_active_importer_starter](https://github.com/CloudoLife-Rails/col_active_importer_starter)

[2] [col_active_importer_starter | RubyGems.org | your community gem host - https://rubygems.org/gems/col_active_importer_starter](https://rubygems.org/gems/col_active_importer_starter)

[3] [continuum/active_importer: Define importers that load tabular data from spreadsheets or CSV files into any ActiveRecord-like ORM. - https://github.com/continuum/active_importer](https://github.com/continuum/active_importer)

[4] [weshatheleopard/rubyXL: Ruby lib for reading/writing/modifying .xlsx and .xlsm files - https://github.com/weshatheleopard/rubyXL](https://github.com/weshatheleopard/rubyXL)

[5] [rubyXL | RubyGems.org | your community gem host - https://rubygems.org/gems/rubyXL/](https://rubygems.org/gems/rubyXL/)

[6] [RubyGems.org | your community gem host - https://rubygems.org/](https://rubygems.org/)

