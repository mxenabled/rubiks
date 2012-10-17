require 'spec_helper'

describe 'Rubiks::Cube' do
  it 'has a name' do
    assert_equal 'Unknown', Rubiks::Cube.new.name
  end
end
