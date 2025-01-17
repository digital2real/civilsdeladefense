# frozen_string_literal: true

require "rails_helper"

RSpec.describe JobApplicationFileType, type: :model do
  it { is_expected.to validate_presence_of(:name) }
end

# == Schema Information
#
# Table name: job_application_file_types
#
#  id                :uuid             not null, primary key
#  by_default        :boolean          default(FALSE)
#  content_file_name :string
#  description       :string
#  from_state        :integer
#  kind              :integer
#  name              :string
#  notification      :boolean          default(TRUE)
#  position          :integer
#  spontaneous       :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
