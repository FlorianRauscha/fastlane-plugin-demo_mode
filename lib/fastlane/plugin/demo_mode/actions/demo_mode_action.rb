
module Fastlane
  module Actions
    class DemoModeAction < Action
      def self.run(config)
        devices = Actions.sh("adb devices | tail -n +2 | cut -f1")

        for device in devices.each_line
          device = device.strip
          next if device.empty?

          UI.message("Set demo mode on " + device)

          command = "adb -s #{device} shell am broadcast -a com.android.systemui.demo -e command "
          showWifi = config[:wifi] ? "show" : "hide"
          showMobile = config[:mobile] ? "show" : "hide"

          Actions.sh("adb -s #{device} shell settings put global sysui_demo_allowed 1")

          if config[:deactivate]
            Actions.sh(command + "exit")
          else
            Actions.sh(command + "enter")
            Actions.sh(command + "clock -e hhmm #{config[:clock]}")
            Actions.sh(command + "battery -e level #{config[:battery]}")
            Actions.sh(command + "battery -e plugged #{config[:plugged]}")
            Actions.sh(command + "network -e wifi #{showWifi} -e level #{config[:wifi_level]}")
            Actions.sh(command + "network -e mobile #{showMobile} -e datatype #{config[:mobile_datatype]} -e level #{config[:mobile_level]}")
            Actions.sh(command + "notifications -e visible #{config[:notifications]}")
          end
        end
      end

      def self.description
        "Sets your device to demo mode"
      end

      def self.authors
        ["Florian Rauscha"]
      end

      def self.details
        # Optional:
        "Set your devices to demo mode before creating screenshots"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :deactivate,
            description: "Deactivate demo mode (default: false)",
            optional: true,
            is_string: false,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :clock,
            description: "Set clock (default: 0700)",
            optional: true,
            default_value: "0700",
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :wifi,
            description: "Show wifi (default: true)",
            optional: true,
            is_string: false,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :wifi_level,
            description: "Set wifi level (default: 4)",
            optional: true,
            default_value: 4,
            type: Integer
          ),
          FastlaneCore::ConfigItem.new(
            key: :mobile,
            description: "Show mobile (default: true)",
            optional: true,
            is_string: false,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :mobile_datatype,
            description: "Set mobile datatype (default: none)",
            optional: true,
            default_value: "none",
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :mobile_level,
            description: "Set mobile level (default: 4)",
            optional: true,
            default_value: 4,
            type: Integer
          ),
          FastlaneCore::ConfigItem.new(
            key: :battery,
            description: "Set battery status (default: 100)",
            optional: true,
            default_value: 100,
            type: Integer
          ),
          FastlaneCore::ConfigItem.new(
            key: :plugged,
            description: "Is the battery plugged (default: false)",
            optional: true,
            is_string: false,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :notifications,
            description: "Show notifications (default: false)",
            optional: true,
            is_string: false,
            default_value: false
          )
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
