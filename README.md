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

[jruby]: http://jruby.org
[wiki_cube]: http://en.wikipedia.org/wiki/OLAP_cube
[wiki_olap]: http://en.wikipedia.org/wiki/Online_analytical_processing
[wiki_mdx]: http://en.wikipedia.org/wiki/MultiDimensional_eXpressions
[wiki_open_source]: http://en.wikipedia.org/wiki/Open-source_software
[wiki_java]: http://en.wikipedia.org/wiki/Java_(programming_language)
[wiki_data_warehouse]: http://en.wikipedia.org/wiki/Data_warehouse
[wiki_star_schema]: http://en.wikipedia.org/wiki/Star_schema
[wiki_dimensional_modeling]: http://en.wikipedia.org/wiki/Dimensional_modeling
[postgresql]: http://www.postgresql.org
[mondrian]: http://mondrian.pentaho.com
[mondrian_schema]: http://mondrian.pentaho.com/documentation/schema.php
[rails]: http://rubyonrails.org

Rubiks is a [Online Analytical Processing][wiki_olap] ( **OLAP** ) library written in [JRuby][jruby].
It runs on top of [Mondrian][mondrian] (an [Open-source][wiki_open_source] [OLAP][wiki_olap] server
written in [Java][wiki_java]) and provides the ability to:

* define a [OLAP][wiki_olap] schema in Ruby
* generate a [Mondrian XML schema][mondrian_schema] from this definition
* execute [MultiDimensional eXpressions][wiki_mdx] ( **MDX** ) queries against the OLAP server


### Assumptions

* You are using [JRuby][jruby]
* You are using [PostgreSQL][postgresql]
* You have designed and populated your [Data Warehouse][wiki_data_warehouse] (see [Dimensional Modeling][wiki_dimensional_modeling] and [Star Schema][wiki_star_schema])
* You are using [Ruby on Rails][rails] database naming conventions


### Installation

Run `gem install rubiks` to install the gem on its own.

Or you can add the following to your Gemfile and run the `bundle` command to install it.

    gem 'rubiks'


### Schema Example

After installing the gem, fire up an IRB session with `irb` or `bundle exec irb` if you are using Bundler, and follow this (or even paste it into your session):

```ruby
require 'rubiks'

schema = ::Rubiks::Schema.define :banking do
  cube :transactions do
    dimension :date, :type => 'TimeDimension' do
      hierarchy :yqmwd, :caption => 'YQMWD' do
        level :year,    :level_type => 'TimeYears', :type => :numeric, :contiguous => true
        level :quarter, :level_type => 'TimeQuarters', :type => :numeric, :contiguous => true, :cardinality => :low
        level :month,   :level_type => 'TimeMonths', :type => :numeric, :contiguous => true
        level :week,    :level_type => 'TimeWeeks', :type => :numeric, :column => :week_of_month, :contiguous => true, :cardinality => :low
        level :day,     :level_type => 'TimeDays', :type => :numeric, :contiguous => true
      end
    end

    dimension :account do
      hierarchy :account_type do
        level :asset_liability, :cardinality => :low
        level :account_type
      end
    end

    measure :count, :column => :quantity
    measure :amount, :aggregator => :sum, :format_string => '$#,###'
  end
end

puts schema.to_xml
```

You should see this XML:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<schema name="Banking">
  <cube name="Transactions">
    <table name="view_transactions"/>
    <dimension name="Date" foreignKey="date_id" type="TimeDimension">
      <hierarchy name="YQMWD" hasAll="true" primaryKey="id">
        <table name="view_dates"/>
        <level name="Year" column="year" levelType="TimeYears" type="Numeric"/>
        <level name="Quarter" column="quarter" levelType="TimeQuarters" type="Numeric"/>
        <level name="Month" column="month" levelType="TimeMonths" type="Numeric"/>
        <level name="Week" column="week_of_month" levelType="TimeWeeks" type="Numeric"/>
        <level name="Day" column="day" levelType="TimeDays" type="Numeric"/>
      </hierarchy>
    </dimension>
    <dimension name="Account" foreignKey="account_id">
      <hierarchy name="Account Type" hasAll="true" primaryKey="id">
        <table name="view_accounts"/>
        <level name="Asset Liability" column="asset_liability"/>
        <level name="Account Type" column="account_type"/>
      </hierarchy>
    </dimension>
    <measure name="Count" column="quantity" aggregator="count"/>
    <measure name="Amount" column="amount" aggregator="sum" formatString="$#,###"/>
  </cube>
</schema>
```


### Similar projects

Check out these projects (which have been super helpful in working on Rubiks):

* [Mondrian (git)](https://github.com/pentaho/mondrian) - source code for Mondrian on GitHub
* [mondrian-olap](https://github.com/rsim/mondrian-olap) - a RubyGem wrapping Mondrian
* [Saiku](http://analytical-labs.com) ([Saiku on GitHub](https://github.com/OSBI/saiku)) - a modular open-source analysis suite offering lightweight OLAP which remains easily embeddable, extendable and configurable.


### Contributing

If you'd like to contribute to Rubiks, that's awesome, and we <3 you. There's a guide to contributing
(both code and general help) over in [CONTRIBUTING.md](CONTRIBUTING.md)


### Development

To see what has changed in recent versions, see the [CHANGELOG.md](CHANGELOG.md).
