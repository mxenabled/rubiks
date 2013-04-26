shared_examples 'a named object' do
  subject { described_class.new }

  it { should respond_to :json_hash }
  it { should respond_to :to_json }
  it { should respond_to :to_xml }

  it { should respond_to :name }
  it { should respond_to :caption }
  it { should respond_to :description }
  it { should respond_to :visible }
end
