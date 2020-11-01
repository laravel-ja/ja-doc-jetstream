# 認証

[[toc]]

## イントロダクション

Laravel Jetstreamはログイン、２要素認証ログイン、ユーザー登録、パスワードリセット、メール確認ビューをプロジェクトへ自動的にスカフォールドします。**簡単にするために、スタックの選択にかかわらずこれらのテンプレートはBladeで書かれており、JavaScriptフレームワークは使用していません。**

![Screenshot of Authentication](/img/authentication.png)

## Laravel Fortify

内部的にJetstreamの認証部分は、認証バックエンドにとらわれないLaravelのフロントエンドである[Laravel Fortify](https://github.com/laravel/fortify)により動作しています。

Jetstreamをインストールすると、同時にアプリケーションへ`config/fortify.php`ファイルが用意されます。この認証ファイルの中で、使用する認証ガードや認証後にユーザーをどこへリダイレクトするかなど、Fortifyの動作の様々な側面をカスタマイズできます。

さらにプロフィール情報やパスワードの更新など、Fortifyの機能はすべて無効にできます。

## ビュー

アプリケーションに選んだスタックにかかわらず、認証関連のビューはBladeテンプレートとして`resources/views/auth`ディレクトリへ保存されます。アプリケーションの必要に合わせこれらのスタイルを自由にカスタマイズできます。

### ビューレンダリングのカスタマイズ

どのように特定の認証ビューをレンダーするかをカスタマイズしたい場合もあります。全認証ビューのレンダーロジックは`Laravel\Fortify\Fortify`クラスの適切なメソッドを修正することで可能です。通常、このメソッドは`JetstreamServiceProvider`の`boot`メソッドで呼び出します。

```php
use Laravel\Fortify\Fortify;

Fortify::loginView(function () {
    return view('auth.login');
});

Fortify::registerView(function () {
    return view('auth.register');
});
```

## アクション

Jetstreamの典型的な機能として、登録／認証リクエストを満たすために実行するロジックはアプリケーションのアクションクラスに見ることができます。

具体的には、アプリケーションでユーザーが登録を更新すると、`App\Actions\Fortify\CreateNewUser`クラスが実行されます。このアクションは、入力の検証とユーザーの作成の責務を負います。

そのため、ロジックをカスタマイズしたければ、このクラスを変更します。アクションは受信リクエストの全入力を含む`$input`配列を引数に受け取ります。

### パスワードバリデーションルール

`App\Actions\Fortify\CreateNewUser`と`App\Actions\Fortify\ResetUserPassword`と`App\Actions\Fortify\UpdateUserPassword`アクションは全部、`App\Actions\Fortify\PasswordValidationRules`トレイトを使用しています。

お気づきになるでしょうが、`App\Actions\Fortify\PasswordValidationRules`トレイトは`Laravel\Fortify\Rules\Password`バリデーションルールオブジェクトを使用しています。このオブジェクトによりアプリケーションに要求するパスワード要件を簡単にカスタマイズできます。デフォルトでは、最低８文字列長のパスワードを要求します。このパスワード要件をカスタマイズするため、以降のメソッドが使用できます。

```php
(new Password)->length(10)

// 最低１文字の大文字が必要
(new Password)->requireUppercase()

// 最低一文字の数字が必要
(new Password)->requireNumeric()

// 最低一文字の特殊文字が必要
(new Password)->requireSpecialCharacter()
```

## 認証プロセスのカスタマイズ

### User認証のカスタマイズ

場合により、ログイン情報をどのように認証するかとかユーザーの取得方法などの全般にわたりカスタマイズしたいこともあるでしょう。`Fortify::authenticateUsing`メソッドを使い簡単にできます。

このメソッドはクロージャを引数に取り、そのクロージャは受信HTTPリクエストを引数に取ります。クロージャはリクエスト中のログイン情報の検証と、該当するユーザーインスタンスを返す責務を担当します。認証情報が検証に失敗したり、該当ユーザーが見つからない場合は、クロージャから`null`か`false`を返します。通常、このメソッドは`JetstreamServiceProvider`の`boot`メソッドで呼び出します。

```php
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Fortify\Fortify;

Fortify::authenticateUsing(function (Request $request) {
    $user = User::where('email', $request->email)->first();

    if ($user &&
        Hash::check($request->password, $user->password)) {
        return $user;
    }
})
```

### 認証パイプラインのカスタマイズ

Jetstreamは（Fortifyにより）、invokableなクラスのパイプラインを通してログインリクエストを認証します。必要であれば、ログインリクエストをパイプにより通す必要のあるクラスのカスタムパイプラインを定義できます。各クラスはミドルウェアのように、受信`Illuminate\Http\Request`インスタンスと`$next`変数を引数に取る`__invoke`メソッドを持つ必要があります。

カスタムパイプラインを定義するには、`Fortify::authenticateThrough`メソッドを使用します。このメソッドはクロージャを受け取り、そのクロージャはログインリクエストをパイプで通すクラスの配列を返す必要があります。通常、このメソッドは、`JetstreamServiceProvider`の`boot`メソッドで呼び出します。

```php
use Laravel\Fortify\Actions\AttemptToAuthenticate;
use Laravel\Fortify\Actions\EnsureLoginIsNotThrottled;
use Laravel\Fortify\Actions\PrepareAuthenticatedSession;
use Laravel\Fortify\Actions\RedirectIfTwoFactorAuthenticatable;
use Laravel\Fortify\Fortify;
use Illuminate\Http\Request;

Fortify::authenticateThrough(function (Request $request) {
    return array_filter([
            config('fortify.limiters.login') ? null : EnsureLoginIsNotThrottled::class,
            RedirectIfTwoFactorAuthenticatable::class,
            AttemptToAuthenticate::class,
            PrepareAuthenticatedSession::class,
    ]);
});
```

## メール確認

Laravel Jetstreamは新しく登録したユーザーのメールアドレスを確認したい要件をサポートしています。しかし、この機能のサポートはデフォルトで無効にしています。有効にするには、`config/fortify.php`設定ファイルの`features`アイテムのコメントを外してください。

```php
'features' => [
    Features::registration(),
    Features::resetPasswords(),
    Features::emailVerification(),
    Features::updateProfileInformation(),
    Features::updatePasswords(),
    Features::twoFactorAuthentication(),
],
```

次に、`App\Models\User`クラスが、`MustVerifyEmail`インターフェイスを実装していることを確認します。このインターフェイスはこのモデルに取り込んであります。

この２ステップを行えば、新しい登録ユーザーはメールアドレスの所有者であると証明することをすすめるメールを受け取るようになります。
