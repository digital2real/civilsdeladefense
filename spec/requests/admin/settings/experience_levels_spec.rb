# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin::Settings::ExperienceLevels", type: :request do
  it_behaves_like "an admin setting", :experience_level, :name, "a new name"
  it_behaves_like "a movable admin setting", :experience_level
end
