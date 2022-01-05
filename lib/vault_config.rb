# 
require 'net/http'
require 'json'

class VaultConfig
  def initialize(app)
    @app = app
  end

  def self.load!(app)
    client = self.new(app)
    client.load!
  end

  def self.load_with_warning(app)
    begin
      client = self.new(app)
      client.load!
    rescue => exception
      puts "Warning: VaultConfig.load error --- ignore \n #{exception.message}"
    end
  end

  # https://learn.hashicorp.com/tutorials/vault/tokens
  def self.renew(token = nil, increment = '12h')
    uri = URI(File.join(ENV['VAULT_ADDR'], '/v1/auth/token/renew'))
    header = {
      'X-Vault-Token':  ENV['VAULT_TOKEN'],
      'content-type':'application/json'
    }
    response = Net::HTTP.post(uri, {
      token: token || ENV['VAULT_TOKEN'],
      increment: increment,
    }.to_json, header)
    JSON.parse(response.body)
  end

  def load!
    ret = get client_uri, headers
    ret['data']['data'].each do |k, v|
      ENV[k] = v
    end
  end

  private def get(uri, headers = {})
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri, headers
      response = http.request request
      return JSON.parse(response.body)
    end
  end

  private def headers
    @headers ||= {}
    @headers['X-Vault-Token'] = ENV['VAULT_TOKEN']
    @headers
  end

  private def client_uri
    @client_uri ||= if @app.start_with?('/')
      arr = @app.split('/')
      arr[1] = "#{arr[1]}/data"
      URI(File.join(ENV['VAULT_ADDR'], 'v1/', arr.join('/')))
    else
      URI(File.join(ENV['VAULT_ADDR'], 'v1/secret/data', @app))
    end
  end
end