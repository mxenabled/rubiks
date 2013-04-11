# Rubiks

[![Gem Version](https://badge.fury.io/rb/rubiks.png)][gem]
[![Build Status](https://secure.travis-ci.org/moneydesktop/rubiks.png?branch=master)][travis]
[![Dependency Status](https://gemnasium.com/moneydesktop/rubiks.png?travis)][gemnasium]
[![Code Climate](https://codeclimate.com/github/moneydesktop/rubiks.png)][codeclimate]
[![Coverage Status](https://coveralls.io/repos/moneydesktop/rubiks/badge.png?branch=master)][coveralls]

[gem]: https://rubygems.org/gems/rubiks
[travis]: http://travis-ci.org/moneydesktop/rubiks
[gemnasium]: https://gemnasium.com/moneydesktop/rubiks
[codeclimate]: https://codeclimate.com/github/moneydesktop/rubiks
[coveralls]: https://coveralls.io/r/moneydesktop/rubiks

A gem to allow defining an OLAP schema from a hash and generating an XML schema for Mondrian.

## Installation

Run `gem install rubiks` to install the gem on its own.

Or you can add the following to your Gemfile and run the `bundle` command to install it.

    gem 'rubiks'

## Examples

This is an example taken from the [Mondrian documentation](http://mondrian.pentaho.com/documentation/schema.php#Cubes_and_dimensions) (then simplified a little and modified to use some Rails/Rubiks conventions)

After installing the gem, fire up an IRB session with `irb` or `bundle exec irb` if you are using Bundler, and follow this (or even paste it into your session):

```ruby
require 'rubiks/examples'

md = Rubiks::Examples::MondrianDocs.new

md.filename           # => "/path/to/rubiks/examples/mondrian_docs.yml"

puts md.file_contents # see the YAML section below

puts md.to_xml        # see the XML section below
```

The [example YAML file](examples/mondrian_docs.yml) contents are:

```yaml
cubes:
  - name: sales
    dimensions:
      - name: date
        hierarchies:
          - name: year_quarter_month
            levels:
              - name: year
                column: the_year
                data_type: numeric

              - name: quarter
                data_type: string

              - name: month
                column: month_of_year
                data_type: Numeric

    measures:
      - name: unit_sales
        aggregator: sum
        format_string: '#,###'

      - name: store_sales
        aggregator: sum
        format_string: '#,###'

      - name: store_cost
        aggregator: sum
        format_string: '#,###'

    calculated_members:
      - name: profit
        dimension: measures
        formula: '[Measures].[Store Sales] / [Measures].[Store Cost]'
        format_string: '$#,##0.00'
```

and the generated XML is:


```xml
<?xml version="1.0" encoding="UTF-8"?>
<schema name="default">
  <cube name="Sales">
    <table name="view_sales"/>
    <dimension name="Date" foreignKey="date_id">
      <hierarchy name="Year Quarter Month" primaryKey="id" hasAll="true">
        <table name="view_dates"/>
        <level name="Year" column="the_year" type="Numeric"/>
        <level name="Quarter" column="quarter" type="String"/>
        <level name="Month" column="month_of_year" type="Numeric"/>
      </hierarchy>
    </dimension>
    <measure name="Unit Sales" aggregator="sum" formatString="#,###" column="unit_sales"/>
    <measure name="Store Sales" aggregator="sum" formatString="#,###" column="store_sales"/>
    <measure name="Store Cost" aggregator="sum" formatString="#,###" column="store_cost"/>
    <calculatedMember name="Profit" dimension="Measures" formula="[Measures].[Store Sales] / [Measures].[Store Cost]">
      <calculatedMemberProperty name="FORMAT_STRING" value="$#,##0.00"/>
    </calculatedMember>
  </cube>
</schema>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
