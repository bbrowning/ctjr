class DeploymentsController < ApplicationController
  navigation :deployments
  before_filter :require_user

  # GET /deployments
  # GET /deployments.xml
  def index
    @deployments = current_user.deployments.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deployments }
    end
  end

  # GET /deployments/1
  # GET /deployments/1.xml
  def show
    @deployment = current_user.deployments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @deployment }
    end
  end

  # GET /deployments/new
  # GET /deployments/new.xml
  def new
    @deployment = current_user.deployments.new(params[:deployment])
    @deployment.datasource ||= "local"

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @deployment }
    end
  end

  # POST /deployments
  # POST /deployments.xml
  def create
    @deployment = current_user.deployments.new(params[:deployment])

    respond_to do |format|
      if @deployment.save
        unless @deployment.environment.running?
          @deployment.environment.start!
        end
        format.html { redirect_to(@deployment.app, :notice => 'Application was successfully deployed.') }
        format.xml  { render :xml => @deployment, :status => :created, :location => @deployment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @deployment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deployments/1
  # DELETE /deployments/1.xml
  def destroy
    @deployment = current_user.deployments.find(params[:id])
    @deployment.undeploy!

    respond_to do |format|
      format.html { redirect_back_or_default(@deployment.app, :notice => 'Application was successfully undeployed.') }
      format.xml  { head :ok }
    end
  end
end
