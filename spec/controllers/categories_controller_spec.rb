# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoriesController, type: :controller do
  let(:attributes) { { label: "Sample Category" } }

  describe "GET #index" do
    it "returns a success response" do
      Category.create! attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      category = Category.create! attributes
      get :show, params: { id: category.to_param }
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      category = Category.create! attributes
      get :edit, params: { id: category.to_param }
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Category" do
        expect do
          post :create, params: { category: attributes }
        end.to change(Category, :count).by(1)
      end

      it "redirects to the created category" do
        post :create, params: { category: attributes }
        expect(response).to redirect_to(edit_category_url(Category.last))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) { { label: "New Category Name" } }

      it "updates the requested category" do
        category = Category.create! attributes
        put :update, params: { id: category.to_param, category: new_attributes }

        category.reload

        expect(category.label).to eq("New Category Name")
        expect(category.slug).to eq("new-category-name")
      end

      it "redirects to the category" do
        category = Category.create! attributes
        put :update, params: { id: category.to_param, category: attributes }
        expect(response).to redirect_to(category)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      category = Category.create! attributes

      expect do
        delete :destroy, params: { id: category.to_param }
      end.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = Category.create! attributes
      delete :destroy, params: { id: category.to_param }
      expect(response).to redirect_to(categories_url)
    end
  end
end
