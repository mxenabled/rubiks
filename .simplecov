require 'simplecov-gem-adapter'

SimpleCov.use_merging true
SimpleCov.start 'gem' do
  merge_timeout 3600
end
