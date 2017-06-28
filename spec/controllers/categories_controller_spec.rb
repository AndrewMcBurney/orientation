# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  let(:valid_attributes) { { label: "Sample Category" } }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Category.create! valid_attributes

      get :index,
          params: {},
          session: valid_session

      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      category = Category.create! valid_attributes

      get :show,
          params: { id: category.to_param },
          session: valid_session

      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new,
          params: {},
          session: valid_session

      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      category = Category.create! valid_attributes

      get :edit,
          params: { id: category.to_param },
          session: valid_session

      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Category" do
        expect do
          post :create,
               params: { category: valid_attributes },
               session: valid_session
        end.to change(Category, :count).by(1)
      end

      it "redirects to the created category" do
        post :create,
             params: { category: valid_attributes },
             session: valid_session

        expect(response).to redirect_to(edit_category_url(Category.last))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) do
        skip("Add a hash of attributes valid for your model")
      end

      it "updates the requested category" do
        category = Category.create! valid_attributes

        put :update,
            params: { id: category.to_param, category: new_attributes },
            session: valid_session

        category.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the category" do
        category = Category.create! valid_attributes

        put :update,
            params: { id: category.to_param, category: valid_attributes },
            session: valid_session

        expect(response).to redirect_to(category)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      category = Category.create! valid_attributes
      expect do
        delete :destroy,
               params: { id: category.to_param },
               session: valid_session
      end.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = Category.create! valid_attributes

      delete :destroy,
             params: { id: category.to_param },
             session: valid_session

      expect(response).to redirect_to(categories_url)
    end
  end
end