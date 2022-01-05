# VaultConfig

Use in easy way

load Secret name : get key-vault from vault path secret/SecretName

transfer then to ENV[key] = vault

```ruby
gem 'vault_config'

VaultConfig.load!(SecretName)

# renew current token
VaultConfig.renew
```

config rails

```bash
# vault config 
RAILS_MASTER_KEY='xxxxx'

EDITOR="code --wait" rails credentials:edit

```
