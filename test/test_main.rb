

require 'minitest/autorun'
require '../lib/vault_config'

class VaultConfigTest < Minitest::Test
  def test_load
    VaultConfig.load!('vault_config_test')
    assert_equal "hello world", ENV["VAULT_CONFIG_TEST"]
  end

  def test_load_path
    VaultConfig.load!('/secret/vault_config_test')
    assert_equal "hello world", ENV["VAULT_CONFIG_TEST"]
  end

  def test_renew_current_token
    token = "s.nKHKfsOvryloafduycFEz9A4"
    resp = VaultConfig.renew(token, '60h')
    puts resp['auth']['lease_duration']
    assert_equal token, resp['auth']['client_token']
  end
end
