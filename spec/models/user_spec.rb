require 'rails_helper'

RSpec.describe User, :type => :model do
	
  describe "valid first name" do
    @user = User.new
    @user.first_name = ""
    it { should validate_presence_of :first_name }
  end
	
end
