

require 'minitest/autorun'
require 'vault_config'

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
    VaultConfig.renew("s.sZ8On3SScVl8bcgGzwdiAA14")
  end
end
