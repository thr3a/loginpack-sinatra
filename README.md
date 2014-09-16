loginpack for Sinatra
====

## Description
sinatraでTwitterOauth認証を行うための簡易サンプル

## Requirement
Rubyの動かせる環境

 - sinatra 1.4.5
 - omniauth 1.2.2
 - omniauth-twitter 1.0.1

## Install
```sh
git clone https://github.com/thr3a/loginpack-sinatra.git
cd loginpack-sinatra
bundle install --path vendor/bundle
```
app.rb内のCONSUMER_KEYとCONSUMER_SECRETを記述する
```sh
bundle exec ruby app.rb  -o 0.0.0.0
```
## Tips

- [公式サイト](http://sinatra.ruby.iijgio.com/p/middleware/twitter_authentication_with_omniauth)が元
- 認証時に得られる```env['omniauth.auth']```の内容は[以下](https://github.com/arunagw/omniauth-twitter#authentication-hash)