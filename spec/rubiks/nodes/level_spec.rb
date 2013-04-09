require 'spec_helper'
# Mondrian level has: unique_members, column, type, name_column, ordinal_column

describe ::Rubiks::Level do
  include_context 'schema_context'

  subject { described_class.new_from_hash }

  specify { subject.respond_to?(:from_hash) }
  specify { subject.respond_to?(:to_hash) }

  context 'when parsed from a valid hash' do
    subject { described_class.new_from_hash(level_hash) }

    its(:to_hash) { should have_key('name') }

    it { should be_valid }

#         <Level name="Year" column="year" type="Numeric" uniqueMembers="true"/>
#         <Level name="Quarter" column="quarter" uniqueMembers="false"/>
#         <Level name="Month" column="month_of_year" type="Numeric" uniqueMembers="false"/>
    describe '#to_xml' do
      it 'renders a level tag with attributes' do
        subject.to_xml.should be_like <<-XML
        <level name="Fake Level" column="fake_level"/>
        XML
      end
    end
  end

  context 'when parsed from an invalid (empty) hash' do
    subject { described_class.new_from_hash({}) }

    it { should_not be_valid }

    describe '#to_xml' do
      it 'renders a level tag' do
        subject.to_xml.should be_like <<-XML
        <level/>
        XML
      end
    end
  end

end
