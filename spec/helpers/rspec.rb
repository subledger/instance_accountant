# -*- encoding : utf-8 -*-
require 'rspec/expectations'
require 'rspec/mocks'

module MiniTest
  class Test
    include ::RSpec::Mocks::ExampleMethods

    def before_setup
      ::RSpec::Mocks.setup
      super
    end

    def after_teardown
      super
      ::RSpec::Mocks.verify
    ensure
      ::RSpec::Mocks.teardown
    end
  end

  class Spec
    include RSpec::Matchers
  end
end
