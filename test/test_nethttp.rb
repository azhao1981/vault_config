require 'minitest/autorun'
# require 'faraday'
require 'net/http'
require 'json'

class VaultConfigTest < Minitest::Test
  def test_ruby268
    # url = 'http://localhost:8200/v1/secret/data/vault_config_test'
    # url = 'http://kms.gezhishirt.club/v1/secret/data/vault_config_test'
    # headers = {'X-Vault-Token' => ENV['VAULT_TOKEN']}
    # response = Net::HTTP.get_response(URI.parse(url).to_s, headers)
    # assert_equal 'hello world', JSON.parse(response.body)['data']['data']['VAULT_CONFIG_TEST']

    uri = URI('http://localhost:8200/v1/secret/data/vault_config_test')

    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri, {'X-Vault-Token' => ENV['VAULT_TOKEN']}

      response = http.request request
      puts response.body
    end
  end

  def test_rubyfaraday
    # Faraday.default_adapter = :net_http
    # url = 'http://localhost:8200/v1/secret/data/vault_config_test'
    # response = Faraday.get(url)
    # headers = {'X-Vault-Token' => ENV['VAULT_TOKEN']}
    # response = Net::HTTP.get_response(URI.parse(url).to_s, headers)
    # assert_equal 'hello world', JSON.parse(response.body)['data']['data']['VAULT_CONFIG_TEST']
  end
end