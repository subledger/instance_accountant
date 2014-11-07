# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift 'lib'

require 'instance_accountant'

Gem::Specification.new do |gem|
  gem.authors     = [ 'Tom Mornini', 'John McKee' ]

  gem.files       = Dir.glob( 'lib/**/*.rb' )

  gem.files       << 'instance_accountant.gemspec'
  gem.files       << 'LICENSE.txt'
  gem.files       << 'Rakefile'
  gem.files       << 'README.md'

  gem.test_files  = Dir.glob( 'spec/**/*.rb' )

  gem.name        = 'instance_accountant'

  gem.description = <<-'EOF'
    The instance_accountant gem is designed to be used to account
    for hourly resource consumption, such as EC2 instances, using
    Subledger, the double-entry accounting API.

    It can account for both cost (amount owed to AWS) as well as price
    (amount owed to instance owner). If you run hourly-billed instances
    for yourself, or for others, and want real-time usage information
    for yourself, and for those paying you for the instance, then this
    gem is for you. :-)

    instance_accountant keeps state in an "hourfile" that contains the
    timestamp of the last hour accounted for. It is intended to be run
    in --daemon mode at startup. It makes no effort to account for
    instance time when it is not running, so it's important to run it
    immediately upon startup, and to make sure that it is always running.
  EOF

  gem.summary     = 'account for hourly instance usage using Subledger'
  gem.version     = InstanceAccountant::VERSION
  gem.email       = 'admin@subledger.com'
  gem.licenses    = ['BSD 3-Clause']

  gem.homepage    = 'https://github.com/subledger/instance_accountant'

  gem.bindir      = 'bin'
  gem.executables = 'instance_accountant'

  gem.add_runtime_dependency     'subledger',          '~> 0.7'
  gem.add_runtime_dependency     'thor',               '~> 0.19'

  gem.add_development_dependency 'guard',              '~> 2.8'
  gem.add_development_dependency 'guard-minitest',     '~> 2.3'
  gem.add_development_dependency 'guard-rubocop',      '~> 1.1'
  gem.add_development_dependency 'minitest',           '~> 5.4'
  gem.add_development_dependency 'rake',               '~> 10.3'
  gem.add_development_dependency 'rb-fsevent',         '~> 0.9'
  gem.add_development_dependency 'rspec-expectations', '~> 3.1'
  gem.add_development_dependency 'rspec-mocks',        '~> 3.1'
  gem.add_development_dependency 'rubocop',            '~> 0.27'
end
