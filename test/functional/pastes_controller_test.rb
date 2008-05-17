require File.dirname(__FILE__) + '/../test_helper'
require 'pastes_controller'
require 'erb'

# Re-raise errors caught by the controller.
class PastesController; def rescue_action(e) raise e end; end

class PastesControllerTest < Test::Unit::TestCase
  include ERB::Util
  fixtures :snippets
  def setup
    @controller = PastesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def session
    @request.session
  end

  def test_should_list_pastes_on_index
    get :index
    assert_response :success
    assert_template 'pastes/index'
    assert_equal [snippets(:another), snippets(:first)], assigns(:snippets)
  end

  def test_routing
    with_options :controller => 'pastes' do |test|
      test.assert_routing 'pastes',       :action => 'index'
      test.assert_routing 'pastes/1',      :action => 'show', :id => '1'
      test.assert_routing 'pastes/1.txt', :action => 'show', :format => 'txt', :id => '1'
    end
    
    options = {:controller => 'pastes'}
    assert_recognizes(options.merge(:action => 'create'), {:path => 'pastes',   :method => :post})
    assert_recognizes(options.merge(:action => 'update', :id => '1'), {:path => 'pastes/1',   :method => :put})
    assert_recognizes(options.merge(:action => 'destroy', :id => '1'), {:path => 'pastes/1', :method => :delete})

  end
  
  def test_should_create_a_snippet
    previous_count = Snippet.count
    post :create, :snippet => {:user_name => '', :description => 'Test', 
                            :body => "def hello world;end", :language => 'ruby'}
    assert_equal(previous_count+1, Snippet.count)
    assert_equal 'ruby', Snippet.find(:first).language
    assert_equal flash[:notice], "The key for this paste is #{assigns(:snippet).key}."
    assert_response :redirect
  end

  def test_should_show_a_particular_snippet
    get :show, :id => snippets(:first).id
    assert_response :success
    assert_equal snippets(:first), assigns(:snippet)
  end

  def test_should_redirect_when_invalid_id_specified
    get :show, :id => 'yargle'
    assert_response :redirect
  end

  def test_should_display_a_snippet_as_plain_text
    get :show, :format => 'txt', :id => snippets(:first).id
    assert_response :success
    assert_equal @response.body, snippets(:first).body
  end

  def test_should_not_delete_a_snippet_without_a_valid_key
    assert_no_difference Snippet, :count do
      delete :destroy, :id => 100, :key => '298s'
      assert_response :redirect
      assert_redirected_to :action => 'show', :id => '100'
      assert_equal flash[:error], 'Invalid key for this paste.'
    end
  end

  def test_should_delete_a_snippet_with_valid_key
    assert_difference Snippet, :count, -1 do
      delete :destroy, :id => 100, :key => '298s928s'
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
  end

  def test_should_not_delete_a_snippet_with_hacky_sql
    assert_no_difference Snippet, :count do
      delete :destroy, :id => 100, :key => '(SELECT key FROM snippets WHERE id = 100)'
      assert_response :redirect
      assert_redirected_to :action => 'show', :id => '100'
      assert_equal flash[:error], 'Invalid key for this paste.'
    end
  end
end
