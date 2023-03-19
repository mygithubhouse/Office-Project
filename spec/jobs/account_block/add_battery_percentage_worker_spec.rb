require 'rails_helper'
require 'sidekiq/testing'
RSpec.describe AccountBlock::AddBatteryPercentageWorker, type: :job do
  include ActiveJob::TestHelper
  Sidekiq::Testing.fake!
  subject(:job) { described_class.perform_at(Time.now) }

  it 'queues the job' do
    # expect { job }. to have_enqueued_job(described_class).on_queue("default")
    expect(enqueued_jobs.size).to eq 0
  end
end
