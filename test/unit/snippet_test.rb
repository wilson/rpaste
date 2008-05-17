require File.dirname(__FILE__) + '/../test_helper'

class SnippetTest < Test::Unit::TestCase
  fixtures :snippets

  def test_should_prevent_empty_posts
    snippet = Snippet.new :user_name => 'Nobody', :description => 'Invalid',
      :language => 'text', :body => ''
    assert !snippet.valid?
  end

  def test_should_have_default_description
    snippet = Snippet.create :user_name => 'Somebody', :body => 'hello there', :language => 'text'
    assert_equal "No Description", snippet.description
  end

  def test_should_have_default_user_name
    snippet = Snippet.create :body => 'hello again', :language => 'text', :description => "Something Fun"
    assert_equal "Anonymous", snippet.user_name
  end

  def test_should_show_friendly_language_name
    snippet = Snippet.create :body => '<br/>', :language => 'xml'
    assert_equal 'XML', snippet.language_name
  end

  def test_should_create_key_for_snippet
    snippet = Snippet.create :body => 'test', :language => 'text'
    assert !snippet.key.blank?
  end
end
