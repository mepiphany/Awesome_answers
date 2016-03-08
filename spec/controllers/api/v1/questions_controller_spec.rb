require 'rails_helper'

RSpec.describe Api::V1::QuestionsController, type: :controller do
  # we need to call the `render_views` method because RSpec controller tests
  # don't automatically render the view files. In this case we're using jbuilder
  # templates which are views. So we need to explicit about telling RSpec to
  # render views.
  render_views

  describe "Fetching a list of questions" do
    context "with valid api key" do
      it "includes the quesions's title" do
        user = User.create(first_name: "Tam", last_name: "Kbeili",
                           email: "tam@codecore.ca", password: "supersecret")
        question = Question.create(title: "Awesome Question", body: "Hello World!")
        get :index, api_key: user.api_key, format: :json
        expect(response.body).to match(/#{question.title}/i)
      end

      it "includes teh question's body" do
        user = User.create(first_name: "Tam", last_name: "Kbeili",
                           email: "tam@codecore.ca", password: "supersecret")
        question = Question.create(title: "Awesome Question", body: "Hello World!")
        get :index, api_key: user.api_key, format: :json
        parsed_json = JSON.parse(response.body)
        expect(parsed_json[0]["body"]).to eq(question.body)
      end
    end

    context "With invalid api key" do
      it "returns a 401 HTTP response code" do
        get :index, format: :json
        expect(response.code).to eq("401")
      end
    end
  end
end
