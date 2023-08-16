# Flutter Intl nvim plugin

This is nvim plugin which uses [intl_utils](https://pub.dev/packages/intl_utils) package. Simplified version of [VScode plugin](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl)

## Available Commads

### :FlutterIntlGenerate

runs shell command `fvm flutter pub run intl_utils:generate`

### :FlutterIntlDownload

If you are using Localizely you can easily download it with this command

runs shell command `fvm flutter pub run intl_utils:localizely_download`

requires LOCALIZELY_TOKEN as env variable in .zshrc/.bashrc

### :FlutterIntlUpload

If you are using Localizely you can easily upload main .arb file with this command

runs shell command `fvm flutter pub run intl_utils:localizely_upload_main`

requires LOCALIZELY_TOKEN as env variable in .zshrc/.bashrc
