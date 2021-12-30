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

  # https://learn.hashicorp.com/tutorials/vault/tokens
  def self.renew(token = nil)
    uri = URI(File.join(ENV['VAULT_ADDR'], '/v1/auth/token/renew'))
    header = {
      'X-Vault-Token':  ENV['VAULT_TOKEN'],
      'content-type':'application/json'
    }
    response = Net::HTTP.post(uri, {
      token: token || ENV['VAULT_TOKEN'],
      increment: "60"
    }.to_json, header)
    puts response.body
  end

  def load!
    header = {'X-Vault-Token': ENV['VAULT_TOKEN']}
    response = Net::HTTP.get_response(client_uri, header)
    JSON.parse(response.body)['data']['data'].each do |k, v|
      ENV[k] = v
    end
  end

  private def client_uri
    if @app.start_with?('/')
      arr = @app.split('/')
      arr[1] = "#{arr[1]}/data"
      URI(File.join(ENV['VAULT_ADDR'], 'v1/', arr.join('/')))
    else
      URI(File.join(ENV['VAULT_ADDR'], 'v1/secret/data', @app))
    end
  end
end