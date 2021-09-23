require 'tmpdir'
require 'fileutils'

describe Solargraph::ApiMap::BundlerMethods do
  # @todo Skipping Bundler-related tests on JRuby
  next if RUBY_PLATFORM == 'java'

  before :all do
    Dir.chdir 'spec/fixtures/workspace' do
      o, e, s = Open3.capture3('bundle', 'install')
      raise RuntimeError, e unless s.success?
    end
  end

  after :all do
    File.unlink 'spec/fixtures/workspace-with-gemfile/Gemfile.lock'
  end

  it 'finds default gems from bundler/require' do
    result = Solargraph::ApiMap::BundlerMethods.require_from_bundle('spec/fixtures/workspace-with-gemfile')
    expect(result.keys).to eq(['backport', 'bundler'])
  end

  it 'does not raise an error without a bundle' do
    expect {
      Dir.mktmpdir do |dir|
        Solargraph.with_clean_env do
          Solargraph::ApiMap::BundlerMethods.require_from_bundle(dir)
        end
      end
    }.not_to raise_error
  end
end
