RSpec.describe <%= class_name %>Controller, type: :controller do

<% actions.each do |action| %>
  describe "GET #<%= action %>" do
    it "returns http success" do
      get :<%= action %>
      expect(response).to have_http_status(:success)
    end
  end

<% end %>
end
