require 'digest/md5'
class Snippet < ActiveRecord::Base
  LANGUAGE_OPTIONS = {"Ruby" => "ruby", "Text" => "text", "XML" => "xml", "YAML" => "yaml"}
  validates_inclusion_of :language, :in => LANGUAGE_OPTIONS.values
  validates_presence_of :language
  validates_length_of :user_name, :maximum => 30
  validates_length_of :description, :maximum => 40
  validates_length_of :body, :in => 1..32000
  
  def description
    desc = read_attribute(:description)
    desc.blank? ? "No Description" : desc
  end
  
  def user_name
    name = read_attribute(:user_name)
    name.blank? ? "Anonymous" : name
  end

  def language_name
    LANGUAGE_OPTIONS.invert[self.language] || "Unknown Language"
  end

  def creation_time
    self.created_at.to_formatted_s(:db) rescue "Unknown Time"
  end

  before_create :create_key

  protected
  def create_key
    self.key = Digest::MD5.hexdigest(self.body + Time.now.to_s)[0..7]
  end

end
