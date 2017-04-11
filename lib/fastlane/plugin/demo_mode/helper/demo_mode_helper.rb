module Fastlane
  module Helper
    class DemoModeHelper
      # class methods that you define here become available in your action
      # as `Helper::DemoModeHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the demo_mode plugin helper!")
      end
    end
  end
end
