describe Fastlane::Actions::DemoModeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The demo_mode plugin is working!")

      Fastlane::Actions::DemoModeAction.run(nil)
    end
  end
end
