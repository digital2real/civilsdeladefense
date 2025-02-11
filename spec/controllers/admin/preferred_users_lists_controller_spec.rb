# frozen_string_literal: true

require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
#
# Also compared to earlier versions of this generator, there are no longer any
# expectations of assigns and templates rendered. These features have been
# removed from Rails core in Rails 5, but can be added back in via the
# `rails-controller-testing` gem.

RSpec.describe Admin::PreferredUsersListsController, type: :controller do
  context "when logged in as BANT administrator" do
    login_admin

    # This should return the minimal set of attributes required to create a valid
    # PreferredUsersList. As you add validations to PreferredUsersList, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      build(:preferred_users_list).attributes
    end

    let(:invalid_attributes) do
      {name: ""}
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new PreferredUsersList" do
          expect {
            post :create, params: {preferred_users_list: valid_attributes}
          }.to change(PreferredUsersList, :count).by(1)
        end

        it "redirects to the created preferred_users_list" do
          post :create, params: {preferred_users_list: valid_attributes}
          expect(response.status).to eq(302)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {preferred_users_list: invalid_attributes}
          expect(response).not_to be_successful
        end
      end
    end
  end

  context "when logged in as Employeur administrator" do
    login_employer

    # This should return the minimal set of attributes required to create a valid
    # PreferredUsersList. As you add validations to PreferredUsersList, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      build(:preferred_users_list).attributes
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new PreferredUsersList" do
          expect {
            post :create, params: {preferred_users_list: valid_attributes}
          }.to change(PreferredUsersList, :count).by(1)
        end
      end
    end
  end

  context "when logged in as Grand Employeur administrator" do
    login_grand_employer

    # This should return the minimal set of attributes required to create a valid
    # PreferredUsersList. As you add validations to PreferredUsersList, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      build(:preferred_users_list).attributes
    end

    describe "POST #create" do
      context "with valid params" do
        it "does not create a new PreferredUsersList" do
          expect {
            post :create, params: {preferred_users_list: valid_attributes}
          }.not_to change(PreferredUsersList, :count)
          expect(response).not_to be_successful
        end
      end
    end
  end
end
