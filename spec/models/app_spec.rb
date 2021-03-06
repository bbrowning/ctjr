require 'spec_helper'

describe App do

  it "should require a name attribute" do
    app = App.new
    app.save
    app.should have(1).error_on(:name)
  end

  it "should belong to a user" do
    App.new.should respond_to(:user)
  end

  it "should not be able to mass-assign user attribute" do
    app = App.new(:user => User.new)
    app.user.should be_nil
  end

  it "should have many app versions" do
    App.new.should respond_to(:app_versions)
  end

  it "should have many deployments" do
    App.new.should respond_to(:deployments)
  end
end
