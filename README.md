## Step one: build your image
- docker build . -t your_company:1.0.0

## Runners
- bin/console -h

```
Usage: bin/console [--option value]
    -p, --persisted FILE             Persisted mode
    -k, --key APP_KEY                Application Key Generator, must be exported to APP_KEY environment variable or config.yml
    -s, --secret SECRET              Encrypt Key Generator, must be exported to SECRET environment variable or config.yml
```

## 01 - Setup App
![Alt Text](../docs/01-app_setup.gif)

## 02 - App Login: with persisted mode
![Alt Text](../docs/02-app_loggin_persisted.gif)

## 03 - User Login/Logout: create users
![Alt Text](../docs/03-login_logout_create_user.gif)
