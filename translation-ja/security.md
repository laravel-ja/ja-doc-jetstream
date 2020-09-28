# セキュリティ

[[toc]]

## イントロダクション

Laravel Jetstreamのセキュリティ機能は、ユーザーが右上にあるプロフィールナビゲーションのドロップダウンメニューからアクセスします。Jetstreamのスカフォールドしたビューとアクションは、ユーザーのパスワード更新、２要素認証の有効／無効切り替え、他のブラウザのセッションのログアウトを提供します。

![Screenshot of Security](./../../assets/img/security.png)

### ２要素認証

Laravel Jetstreamは自動的に全Jetstreamアプリケーションへ２要素認証をサポートするスカフォールドを生成します。ユーザーが自分のアカウントで２要素認証を有効にしたら、Google認証システムのような無料の認証アプリケーションを使用する、QRコードをスキャンする必要があります。更に、1Passwordのようなセキュアなパスワードマネージャーへリストしたリカバリーコードを保存する必要もあります。

ユーザーがモバイルデバイスへアクセスできなくなった場合、Jetstreamのログインビューはモバイルデバイスの認証アプリケーションが提供する一時トークンの代わりに、回復コードの1つを使用して認証できるようにします。

## ビュー／ページ

通常、この機能のビューとページにはカスタマイズすべきでありません。既に完全な機能が提供されているからです。ですが、以下に説明します。

### パスワード更新

Livewire stack使用時は、`resources/views/profile/update-password-form.blade.php` Bladeテンプレートを使用しパスワード更新ビューを表示します。Inertiaスタック使用時は、`resources/js/Pages/Profile/UpdatePasswordForm.vue`テンプレートを使用しこのビューを表示します。

### ２要素認証

Livewire stack使用時は、`resources/views/profile/two-factor-authentication-form.blade.php` Bladeテンプレートを使用して２要素認証管理ビューを表示します。Inertiaスタック使用時は、`resources/js/Pages/Profile/TwoFactorAuthenticationForm.vue`テンプレートを使用してこのビューを表示します。

### ブラウザセッション

Livewireスタックを使用時は、`resources/views/profile/logout-other-browser-sessions-form.blade.php` Bladeテンプレートを使用しブラウザセッション管理ビューを表示します。Inertiaスタック時は、`resources/js/Pages/Profile/LogoutOtherBrowserSessionsForm.vue`を使用しこのビューを表示します。

現在のユーザーとして認証済みな他のブラウザのセッションを安全にログアウトするために、この機能はLaravel組み込みの`AuthenticateSession`ミドルウェアを使用しています。

## アクション

Jetstreamの典型的な機能として、セキュリティ関連のリクエストを満たすために実行するロジックはアプリケーションのアクションクラスに見ることができます。ただし、パスワード更新のみカスタマイズ可能です。一般的に２要素認証とブラウザセッションのアクションはJetstreamにカプセル化したままにすべきであり、カスタマイズは必要ありません。

### パスワード更新

ユーザーが自分のパスワードを更新するとき、`App\Actions\Fortify\UpdateUserPassword`クラスが実行されます。このアクションは入力の検証とユーザーパスワードの更新に責任を負います。

このアクションはパスワードに適用するバリデーションルールを決めている`App\Actions\Fortify\PasswordValidationRules`トレイトを使用しています。このトレイトのカスタマイズはユーザー登録、パスワードリセット、パスワード更新へ一律に影響を与えます。

### パスワードバリデーションルール

`App\Actions\Fortify\PasswordValidationRules`トレイトが`Laravel\Fortify\Rules\Password`バリデーションルールオブジェクトを使用していることに、皆さんお気づきでしょう。このオブジェクトはアプリケーションで要供されるパスワードを簡単にカスタマイズさせてくれます。要求されるパスワードはデフォルトで８文字列長です。しかし、以下のメソッドでパスワードへの要件をカスタマイズできます。

```php
(new Password)->length(10)

// 最低１文字の大文字が必要
(new Password)->requireUppercase()

// 最低１文字の数字が必要
(new Password)->requireNumeric()
```

## パスワード確認

アプリケーション構築時、アクション実行前にユーザーへパスワードを確認する必要が起きることはよくあります。Jetstreamはこれを簡単にできるように、機能を組み込んでいます。

### Livewire

Livewireスタックを使用する場合、パスワードの確認アクションが必要なLivewireコンポーネントは`Laravel\Jetstream\ConfirmsPasswords`トレイトを使用しなくてはなりません。次に、`confirms-password` Bladeコンポーネントを使って確認したいアクションをラップしてください。`confirms-password`のラッパーは、ユーザーのパスワードが確認されたときに実行するLivewireアクションを指定するための`wire:then`ディレクティブを含んでいる必要があります。ユーザーのパスワードを確認したら、`auth.password_timeout`設定オプションが定義する秒数が経過するまで、再入力する必要はありません。

```html
<x-jet-confirms-password wire:then="enableAdminMode">
    <x-jet-button type="button" wire:loading.attr="disabled">
        {{ __('Enable') }}
    </x-jet-button>
</x-jet-confirms-password>
```

次に確認するLivewireアクションの中で、`ensurePasswordIsConfirmed`メソッドを呼び出します。これは関連するアクションのはじめに行う必要があります。

```php
/**
 * ユーザーの管理者モードを有効にする
 *
 * @return void
 */
public function enableAdminMode()
{
    $this->ensurePasswordIsConfirmed();

    // ...
}
```

### Inertia

Inertiaスタックを使用している場合、確認したいアクションをJetstreamが提供する`ConfirmsPassword` Vueコンポーネントを使いラップしてください。このラッパーコンポーネントはユーザーのパスワードが確認された時に呼び出すべきメソッドを起動するための`@confirmed`イベントをリッスンする必要があります。一度パスワードが確認されれば、`auth.password_timeout`設定オプションで定義してある秒数が経過するまで、再入力する必要はありません。

```js
import JetConfirmsPassword from './Jetstream/ConfirmsPassword'

export default {
    components: {
        JetConfirmsPassword,
        // ...
    },
}
```

次に、確認する必要のあるアクションを起動する要素をコンポーネントでラップします。

```html
<jet-confirms-password @confirmed="enableAdminMode">
    <jet-button type="button" :class="{ 'opacity-25': enabling }" :disabled="enabling">
        Enable
    </jet-button>
</jet-confirms-password>
```

最後に、`password.confirm`ミドルウェアが確認アクションを実行するルートへ確実に指定してください。このミドルウェアはLaravelのデフォルトインストールに含まれています。

```php
Route::post('/admin-mode', function () {
    // ...
})->middleware(['password.confirm']);
```

### パスワード確認方法のカスタマイズ

確認時のユーザーパスワード確認方法をカスタマイズしたい場合も起きるでしょう。そのために、`Fortify::confirmPasswordsUsing`メソッドを使用します。このメソッドはクロージャを引数に取ります。このクロージャは認証済みユーザーインスタンスとリクエストの`password`入力値を引数に取ります。クロージャは指定ユーザーのパスワードが有効の場合に`true`を返します。通常、このメソッドは`JetstreamServiceProvider`の`boot`メソッドで呼び出します。

```php
use Illuminate\Support\Facades\Hash;
use Laravel\Fortify\Fortify;

Fortify::confirmPasswordsUsing(function ($user, string $password) {
    return Hash::check($password, $user->password);
});
```
