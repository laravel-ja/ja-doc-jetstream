# API

[[toc]]

## イントロダクション

Jetstreamはファーストパーティとして[Laravel Sanctum](https://laravel.com/docs/sanctum)を統合しています。Laravel SanctumはSPA(single page applications)モバイルアプリケーションのための軽い認証システムであり、シンプルなトークンベースのAPIです。Sanctumによりアプリケーションの各ユーザーは複数のAPIトークンを生成することができます。どのアクションの実行を許可するのかを指定するアビリティ／パーミッションをトークンへ付加できます。

![Screenshot of Laravel Jetstream API](./../../assets/img/api.png)

デフォルトではAPIトークン生成パネルは、ユーザープロフィールドロップダウンメニューの右上にある"API"リンクからアクセスします。このスクリーンでユーザーは様々なパーミッションを持つSanctum APIトークンを生成できます。

:::tip Sanctumドキュメント

Sanctumの詳細とどのようにSanctum認証APIへリクエストを発行するかは、[Sanctumのドキュメント](https://laravel.com/docs/sanctum)を参照してください。
:::

## パーミッションの定義

APIトークンで使用できるパーミッションは、アプリケーションの`JetstreamServiceProvider`で、`Jetstream::permissions`を使用し定義します。パーミッションは単なる文字列です。定義できたら、APIトークンへ割り付けます。

```php
Jetstream::defaultApiTokenPermissions(['read']);

Jetstream::permissions([
    'create',
    'read',
    'update',
    'delete',
]);
```

`defaultApiTokenPermissions`メソッドは新しいAPIトークン生成時に、どのパーミンションをデフォルトとするかを指定するために使います。もちろん、もちろんユーザーはトークン作成前にデフォルトパーミッションのチェックを外せません。

## 受信リクエストの認証

Jetstreamアプリケーションへ向けて送られるリクエストはすべて、たとえ`routes/web.php`ファイルで認証済みのルートであっても、Sanctumトークンオブジェクトと関連付けられます。`Laravel\Sanctum\HasApiTokens`トレイトが提供する`tokenCan`メソッドを使用し、特定のパーミンションがトークンに関連付けられているかを判定できます。このトレイトはJetstreamのインストールにより、アプリケーションの`App\Models\User`モデルへ自動的に適用されています。

```php
$request->user()->tokenCan('read');
```

#### ファーストパーティUIが開始するリクエスト

ユーザーが`routes/web.php`ファイル中のルートへリクエストを送ると、そのリクエストは通常クッキーベースの`web`ガートを通じてSanctumにより認証されます。このシナリオではアプリケーションのUIを通じ、ユーザーがファーストパーティリクエストを作成するため、`tokenCan`メソッドは常に`true`を返します。

最初、この振る舞いは奇妙に思えるでしょう。しかし、APIトークンが利用可能であり、 `tokenCan`メソッドにより調べられると常に想定できるため便利です。つまり、アプリケーションの承認ポリシー内ではリクエストにトークンが関連付けられていないことを心配せず、常にこのメソッドを呼び出すことができます。

## APIサポートの無効化

アプリケーションでサードパーティへAPIを提供しない場合は、JetstreamのAPI機能を完全に無効にできます。そのためには、`config/jetstream.php`設定ファイルの`features`設定オプションの中にある関連するエントリをコメントアウトしてください。

```php
'features' => [
    Features::profilePhotos(),
    // Features::api(),
    Features::teams(),
],
```
