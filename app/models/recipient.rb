# frozen_string_literal: true

class Recipient
  include ActiveModel::Model

  attr_accessor :id
  attr_reader :user

  def initialize(id: nil)
    @id = id
    @user = JobApplication.find(@id).user if @id.present?
  end
end
