require 'bundler/setup'
require 'sinatra/base'
require 'rack-rewrite'

# The project root directory
$root = ::File.dirname(__FILE__)

class SinatraStaticServer < Sinatra::Base  

  get(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  post(/.+/) do
    send_sinatra_file(request.path) {404}
  end

  not_found do
    send_sinatra_file('404.html') {"Sorry, I cannot find #{request.path}"}
  end

  def send_sinatra_file(path, &missing_file_block)
    file_path = File.join(File.dirname(__FILE__), 'public',  path)
    file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i  
    File.exist?(file_path) ? send_file(file_path) : missing_file_block.call
  end

end

use Rack::Rewrite do
    r301 %r{^/2015/04/11/upsert-lands-in-postgres-9.5/?$}, '/2015/05/08/upsert-lands-in-postgres-9.5/'
    r301 %r{^/2015/4/11/upsert-lands-in-postgres-9.5/(\?.*)}, '/2015/05/08/upsert-lands-in-postgres-9.5/'
    r301 %r{^/2015/04/11/upsert-lands-in-postgres-9.5/(\?.*)}, '/2015/05/08/upsert-lands-in-postgres-9.5/'
end

run SinatraStaticServer
