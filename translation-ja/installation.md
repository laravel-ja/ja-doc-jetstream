# インストール

[[toc]]

## Jetstreamのインストール

[Laravelインストーラ](https://laravel.com/docs/installation#installing-laravel)を使用している場合は、`--jet`オプションを付けて、Jetstreamで動作するLaravelアプリケーションを生成できます。

```bash
laravel new project-name --jet
```

LaravelインストーラでJetstreamをインストールしたら、データベースをマイグレートしてください。

```bash
php artisan migrate
```

### Composerによるインストール

もしくは、新しいLaravelプロジェクトへJetstreamをインストールするために、Composerを使う方法もあります。

```bash
composer require laravel/jetstream
```

Composerを使用するインストールを選んだ場合は、`jetstream:install`　Artisanコマンドを実行してください。このコマンドは好みのスタック名を引数で指定します。（livewireかinertia）Jetstreamプロジェクトを開始する前に[Livewire](https://laravel-livewire.com)か[Inertia](https://inertiajs.com)のドキュメント全体を読んでおくことを強くおすすめします。付け加えて、チームサポートを有効にする場合は、`--teams`スイッチを使ってください。

#### Livewireと同時にJetstreamをインストール

```bash
php artisan jetstream:install livewire --teams
```

#### Inertiaと同時にJetstreamをインストール

```bash
php artisan jetstream:install inertia --teams
```

#### インストールを完了する

Jetstreamがインストールできたら、NPM依存をインストール・構築し、データベースをマイグレートしてください。

```bash
npm install && npm run dev

php artisan migrate
```

## Jetstreamの構造

### ビュー／ページ

インストールにより、Jetstreamはアプリケーションへ様々なビューやクラスをリソース公開します。Livewireを使う場合、ビューは`resources/views`ディレクトリへリソース公開されます。Inertiaを使用する場合、「ページ」は`resources/js/Pages`ディレクトリへリソース公開されます。これらのビューやページはJetstreamがサポートする機能をすべて含んでおり、必要に応じて自由にカスタマイズできます。Jetstreamはアプリケーションの開始地点だと考えてください。Jetstreamをインストールしたら、なんでも好きなように自由にカスタマイズできます。

#### ダッシュボード

アプリケーションの「メイン」となるビューは、Livewireを使う場合は`resources/views/dashboard.blade.php`、Inertiaを使う場合は、`resources/js/Pages/Dashboard.vue`へリソース公開されます。アプリケーションのメインのビューを作成するスタートポイントとしてこれを自由に使ってください。

### アクション

さらに、「アクション」クラスは、アプリケーションの`app/Actions`ディレクトリへリソース公開されます。これらのアクションクラスは、たとえばチームを作成するとかユーザーを削除するとか、通常Jetstreamの単一機能に対応した、単一のアクションを実行します。Jetstreamのバックエンドの動作を調整したい場合、これらのクラスを自由にカスタマイズしてください。

### Tailwind

インストールにより、JetstreamはTailwind CSSフレームワークを使用しアプリケーションと統合したスカフォールドを提供します。アプリケーションのCSSコンパイル済み出力を構築するために、以降の２ファイルを使用します。アプリケーションの必要に合わせ、これらのファイルは自由に変更してください。

それに付け加え、選択したJetstreamスタックに合わせ、適切な指定関連ディレクトリでPurgeCSSをサポートするように、`tailwind.config.js`ファイルを事前設定しています。

アプリケーションの`package.json`ファイルはアセットコンパイルに使用するNPMコマンドをはじめから準備しています。

```bash
npm run dev

npm run prod

npm run watch
```

### Livewireのコンポーネント

JetstreamはLivewireスタックを活用するために、ボタンやモーダルなど様々なBladeコンポーネントを使用しています。Livewireスタックを使っており、Jetstreamをインストールした後にこれらのコンポーネントをリソース公開したい場合は、`vendor:publish` Artisanコマンドを使います。

```bash
php artisan vendor:publish --tag=jetstream-views
```

## アプリケーションのロゴ

Jetstreamのロゴが最上部のナビと同様に認証ページでも利用されていることに、皆さんお気づきでしょう。Jetstreamの２コンポーネントを変更すれば、ロゴのカスタマイズは簡単です。

### Livewire

Livewire使用の場合、最初にLivewireスタックのBladeコンポーネントをリソース公開します。

```bash
php artisan vendor:publish --tag=jetstream-views
```

次に、`resources/views/vendor/jetstream/components/application-logo.blade.php`、`resources/views/vendor/jetstream/components/authentication-card-logo.blade.php`、`resources/views/vendor/jetstream/components/application-mark.blade.php`にあるSVGをカスタマイズします。

### Inertia

Inertiaスタック使用の場合、最初にJetstreamのBladeコンポーネントをリソース公開します。これらのコンポーネントは、認証テンプレートで使用されています。

```bash
php artisan vendor:publish --tag=jetstream-views
```

次に、`resources/views/vendor/jetstream/components/authentication-card-logo.blade.php`、`resources/js/Jetstream/ApplicationLogo.vue`、`resources/js/Jetstream/ApplicationMark.vue`の中のSVGをカスタマイズしてください。コンポーネントをカスタマイズしたら、最後にアセットを再ビルドします。

```bash
npm run dev
```
