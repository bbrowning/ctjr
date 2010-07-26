require 'spec_helper'

describe EnvironmentsController do
  before(:each) { login }

  def mock_environment(stubs={})
    @mock_environment ||= mock_model(Environment, stubs)
  end

  describe "GET index" do
    it "assigns all environments as @environments" do
      Environment.stub(:find).with(:all).and_return([mock_environment])
      get :index
      assigns[:environments].should == [mock_environment]
    end
  end

  describe "GET show" do
    it "assigns the requested environment as @environment" do
      Environment.stub(:find).with("37").and_return(mock_environment)
      get :show, :id => "37"
      assigns[:environment].should equal(mock_environment)
    end
  end

  describe "GET new" do
    it "assigns a new environment as @environment" do
      Environment.stub(:new).and_return(mock_environment)
      get :new
      assigns[:environment].should equal(mock_environment)
    end
  end

  describe "GET edit" do
    it "assigns the requested environment as @environment" do
      Environment.stub(:find).with("37").and_return(mock_environment)
      get :edit, :id => "37"
      assigns[:environment].should equal(mock_environment)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created environment as @environment" do
        Environment.stub(:new).with({'these' => 'params'}).and_return(mock_environment(:save => true))
        post :create, :environment => {:these => 'params'}
        assigns[:environment].should equal(mock_environment)
      end

      it "redirects to the environments list" do
        Environment.stub(:new).and_return(mock_environment(:save => true))
        post :create, :environment => {}
        response.should redirect_to(environments_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved environment as @environment" do
        Environment.stub(:new).with({'these' => 'params'}).and_return(mock_environment(:save => false))
        post :create, :environment => {:these => 'params'}
        assigns[:environment].should equal(mock_environment)
      end

      it "re-renders the 'new' template" do
        Environment.stub(:new).and_return(mock_environment(:save => false))
        post :create, :environment => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested environment" do
        Environment.should_receive(:find).with("37").and_return(mock_environment)
        mock_environment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :environment => {:these => 'params'}
      end

      it "assigns the requested environment as @environment" do
        Environment.stub(:find).and_return(mock_environment(:update_attributes => true))
        put :update, :id => "1"
        assigns[:environment].should equal(mock_environment)
      end

      it "redirects to the environments list" do
        Environment.stub(:find).and_return(mock_environment(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(environments_path)
      end
    end

    describe "with invalid params" do
      it "updates the requested environment" do
        Environment.should_receive(:find).with("37").and_return(mock_environment)
        mock_environment.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :environment => {:these => 'params'}
      end

      it "assigns the environment as @environment" do
        Environment.stub(:find).and_return(mock_environment(:update_attributes => false))
        put :update, :id => "1"
        assigns[:environment].should equal(mock_environment)
      end

      it "re-renders the 'edit' template" do
        Environment.stub(:find).and_return(mock_environment(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested environment" do
      Environment.should_receive(:find).with("37").and_return(mock_environment)
      mock_environment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the environments list" do
      Environment.stub(:find).and_return(mock_environment(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(environments_path)
    end
  end

end
