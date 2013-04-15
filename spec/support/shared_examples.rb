shared_examples 'an API node' do
  describe 'responds to API methods' do
    it { subject.should respond_to(:from_hash) }
    it { subject.should respond_to(:to_hash) }
    it { subject.should respond_to(:to_xml) }
    it { subject.should respond_to(:to_json) }
  end
end

shared_examples 'an annotated node' do
  describe 'responds to name and display_name' do
    it { subject.should respond_to(:name) }
    it { subject.should respond_to(:display_name) }
  end
end

shared_examples 'a valid annotated node' do
  describe 'to_hash responds to name and display_name' do
    its(:to_hash) { should have_key('name') }
    its(:to_hash) { should have_key('display_name') }
  end
end
