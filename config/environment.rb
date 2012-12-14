# Load the rails application
require File.expand_path('../application', __FILE__)

ActiveSupport::XmlMini.backend = 'LibXML'
# Initialize the rails application
DandooDev::Application.initialize!