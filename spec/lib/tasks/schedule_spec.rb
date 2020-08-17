require 'rails_helper'
require 'rake'

describe 'destroy_all_schedule' do
  before(:all) do
    @rake = Rake::Application.new
    Rake.application = @rake
    Rake.application.rake_require 'tasks/schedule'
    Rake::Task.define_task(:environment)
  end

  describe 'reset_schedule' do
    let(:task) { 'scedule:all_reset' }
    include_context '転職者による予定記入済み'
    include_context 'リクエスト送付済み'
    it '処理成功' do
      expect(BlankSchedule.count).not_to eq 0
      expect(Schedule.count).not_to eq 0
      expect(@rake[task].invoke).to be_truthy
      expect(BlankSchedule.count).to eq 0
      expect(Schedule.count).to eq 0
    end
  end
end
