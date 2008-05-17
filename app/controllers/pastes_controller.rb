class PastesController < ApplicationController
  verify :method => [ :post, :delete ], :only => :delete, :redirect_to => { :action => 'index' }
  before_filter :load_snippet, :only => [ :show, :edit, :update, :destroy ]
  def index
    @snippets = Snippet.find :all, :limit => 10, :order => "id DESC"
  end

  def new
    @snippet = Snippet.new
    @snippet.language ||= 'ruby'
  end

  def create
    @snippet = Snippet.new params[:snippet]
    if request.post? and @snippet.save
      flash[:notice] = "The key for this paste is #{@snippet.key}."
      redirect_to paste_url(:id => @snippet.id)
    elsif request.post?
      render :action => 'new'
    end
  end

  def show
    redirect_to pastes_url if @snippet.nil?
    respond_to do |type|
      type.text { render :text => @snippet.body, :content_type => 'text/plain' }
      type.html
    end
  end

  def update
    if @snippet.update_attributes(params[:snippet])
      flash[:notice] = "Paste has been updated."
    end
    redirect_to paste_url(:id => @snippet)
  end
  
  def destroy
    if params[:key] == @snippet.key 
      @snippet.destroy
      redirect_to pastes_url 
    else 
      flash[:error] = 'Invalid key for this paste.'
      redirect_to paste_url(:id => @snippet)
    end
  end

  protected
  def load_snippet
    @snippet = Snippet.find(params[:id]) rescue redirect_to(pastes_url)
  end
end
