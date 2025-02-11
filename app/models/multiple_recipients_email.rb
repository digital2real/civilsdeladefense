# frozen_string_literal: true

class MultipleRecipientsEmail
  include ActiveModel::Model

  attr_accessor :subject, :body, :job_application_ids, :attachments, :sender

  validates :subject, :body, :sender, :job_application_ids, presence: true

  def initialize(subject: nil, body: nil, job_application_ids: nil, sender: nil, attachments: nil)
    @subject = subject
    @body = body
    @job_application_ids = job_application_ids
    @sender = sender
    @attachments = attachments
  end

  def save(params = {})
    return false unless valid?

    Email.transaction do
      emails.map(&:save!)
      emails.each { |email| ApplicantNotificationsMailer.new_email(email.id).deliver_later(wait: 5.seconds) }
    end
  end

  private

  def emails
    @emails ||= job_application_ids.map { |job_application_id|
      Email.new(
        subject: @subject,
        body: @body,
        job_application: JobApplication.find(job_application_id),
        sender: @sender,
        attachments: @attachments
      )
    }
  end
end
