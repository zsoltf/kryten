module Bay::Nexus::Environment

  def env
    @_env ||= ( ENV['RUBY_ENV'] || ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development')
  end

  def env= e
    @_env = e
  end

end
