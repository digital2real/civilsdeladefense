# frozen_string_literal: false

require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it 'should correcty tell rejected state' do
    job_offer = create(:job_offer)
    job_application = create(:job_application, job_offer: job_offer)

    expect(job_application.rejected_state?).to be false

    job_application.reject!
    expect(job_application.rejected_state?).to be true

    job_application.phone_meeting!
    expect(job_application.rejected_state?).to be false

    job_application.phone_meeting_rejected!
    expect(job_application.rejected_state?).to be true

    job_application.to_be_met!
    expect(job_application.rejected_state?).to be false

    job_application.after_meeting_rejected!
    expect(job_application.rejected_state?).to be true

    job_application.accepted!
    expect(job_application.rejected_state?).to be false

    job_application.contract_drafting!
    expect(job_application.rejected_state?).to be false

    job_application.contract_feedback_waiting!
    expect(job_application.rejected_state?).to be false

    job_application.contract_received!
    expect(job_application.rejected_state?).to be false

    job_application.affected!
    expect(job_application.rejected_state?).to be false
  end

  it 'should correcty tell rejected states from JobOffer class' do
    ary = %w[rejected phone_meeting_rejected after_meeting_rejected]
    expect(JobApplication.rejected_states).to match_array(ary)
  end
end
