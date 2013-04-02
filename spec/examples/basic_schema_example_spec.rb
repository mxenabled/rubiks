require 'spec_helper'

describe 'Basic Schema' do
  let(:described_class) { ::Rubiks::Schema }
  let(:schema_hash) {
    {
      'cubes' => [{
        'name' => 'logins',
        'measures' => [{
          'name' => 'count',
          'column' => 'count',
          'aggregator' => 'sum'
        }],
        'dimensions' => [{
          'name' => 'date',
          'hierarchies' => [{
            'name' => 'day_of_week',
            'levels' => [{
              'name' => 'day_of_week'
            }]
          }]
        }]
      }]
    }
  }

  subject { described_class.new_from_hash(schema_hash) }

  describe '#to_json' do
    it 'generates a JSON string' do
      subject.to_json.should be_kind_of String
    end

    it 'generates a valid JSON string' do
      lambda {
        MultiJson.load(subject.to_json)
      }.should_not raise_error MultiJson::LoadError
    end
  end

end
