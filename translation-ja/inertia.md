# Inertia

[[toc]]

## イントロダクション

Jetstreamが提供しているInertia.jsスタックは、テンプレート言語として[Vue.js](https://vuejs.org)を使います。Inertiaアプリケーションの構築は、多くの部分が典型的なVueアプリケーションの構築と似ています。しかし、Vueのルータの代わりにLaravelのルータを使います。InertiaはLaravelコンポーネントデータの名前を提供することにより、LaravelのバックエンドからVueコンポーネントの単一ファイルをレンダーできるようにする小さなライブラリーです。データはコンポーネントの"props"へ受け渡します。

言い換えればこのスタックは、複雑なクライアントサイドのルーティングを使用せず、Vue.jsのフルパワーを提供します。今まで使ってきたLaravelの標準ルータが使用できます。

Inertiaの使用時、アプリケーションのルートはInertiaの「ページ」をレンダーすることで、レスポンスを返します。これはLaravelのBladeビューを返すのと、とても似ています。

```php
use Illuminate\Http\Request;
use Inertia\Inertia;

/**
 * 一般的なプロフィール設定スクリーンの表示
 *
 * @param  \Illuminate\Http\Request  $request
 * @return \Inertia\Response
 */
public function show(Request $request)
{
    return Inertia::render('Profile/Show', [
        'sessions' => $this->sessions($request)->all(),
    ]);
}
```

Inertiaスタックの使用時、認識しておくべきJetstreamのユニークな機能があります。以降でこうした機能を説明します。

:::tip Inertiaドキュメント

Inertiaスタックを使用する前に、[Inertiaドキュメント](https://inertiajs.com)全体を読んでおくことを強くおすすめします。
:::

## コンポーネント

JetstreamのInertiaスタックで構築するとき、UIの一貫性を支援し使いやすくするため、さまざまなVueコンポーネント（ボタン、パネル、入力、モーダル）を作成します。これらのコンポーネントは使用するもしないも自由です。これらのコンポーネントはアプリケーションの`resources/js/Jetstream`ディレクトリへ設置します。

`resources/js/Pages`ディレクトリ内にあるJetstreamの既存のビュー内で使い方を確認すれば、これらのコンポーネントの使用方法についての洞察を得られるでしょう。

## カスタムレンダリング

`Teams/Show`や`Profile/Show`のようなInertiaページのいくつかは、Jetstream自身の中からレンダーされます。しかしアプリケーション構築時に、そうしたページへ追加のデータを渡す必要が起きることもあるでしょう。そのため、Jetstreamはそうしたページへデータ／propsを渡せるようカスタマイズできるように、`Jetstream::inertia()->whenRendering`メソッドを用意してます。

このメソッドはページの名前とクロージャを引数に取ります。このクロージャは受信HTTPリクエストと、ページに送られる典型的なデフォルトデータの配列を引数に受けます。通常、このメソッドは`JetstreamServiceProvider`の`boot`メソッドの中で呼び出します。

```php
use Illuminate\Http\Request;
use Laravel\Jetstream\Jetstream;

Jetstream::inertia()->whenRendering(
    'Profile/Show',
    function (Request $request, array $data) {
        return array_merge($data, [
            // カスタムデータ…
        ]);
    }
);
```

## フォーム／バリデーションヘルパ

フォームとバリデーションエラーをより簡単に取り扱えるようにするため、[laravel-jetstream](https://github.com/laravel/jetstream-js)NPMパッケージを作成しました。このパッケージはJetstream Inertiaスタックを使用する場合、自動的にインストールされます。

Vueコンポーネントを通じてアクセスされる`$inertia`オブジェクトへ新しい`form`メソッドをこのパッケージは追加します。`form`メソッドはエラーメッセージに簡単にアクセスできるようにし、フォーム送信に成功した時にフォームの状態をリセットするような利便性を提供する新しいフォームオブジェクトを作成するため使用します。

```js
data() {
    return {
        form: this.$inertia.form({
            name: this.name,
            email: this.email,
        }, {
            bag: 'updateProfileInformation',
            resetOnSuccess: true,
        }),
    }
}
```

フォームは`post`、`put`、`delete`メソッドを使用し送信されます。フォーム作成時に指定されたデータはすべて自動的にリクエストへ含まれます。それに付け加え、[Inertiaリクエストオプション](https://inertiajs.com/requests)も指定できます。

```js
this.form.post('/user/profile-information', {
    preserveScroll: true
})
```

フォームのエラーメッセージは`form.error`メッセージを使用してアクセスします。このメソッドは指定したフィールドの最初のエラーメッセージを返します。

```html
<jet-input-error :message="form.error('email')" class="mt-2" />
```

すべてのバリデーションエラーを一次元化したリストは、`errors`メソッドを使用してアクセスできます。この方法は、エラーメッセージを単純なリストで表示するときに便利です。

```html
<li v-for="error in form.errors()">
    {{ error }}
</li>
```

フォームの現在の状態に関する追加情報は`recentlySuccessful`と`processing`メソッドで利用できます。これらのメソッドは無効や「進行中」のUI状態を記述するのに便利です。

```html
<jet-action-message :on="form.recentlySuccessful" class="mr-3">
    Saved.
</jet-action-message>

<jet-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
    Save
</jet-button>
```

Jetstream Inertiaフォームヘルパの使用の詳細は、Jetstreamのインストール時に作成されるInertiaページをレビューし、学んでください。ページはアプリケーションの`resources/js/Pages`ディレクトリに設置しています。

## モーダル

Jetstreamは、`dialog-modal`と`confirmation-modal`の２種類のモーダルを用意しています。`confirmation-modal`は削除など破壊的なアクションを確認するときに使用しますが、一方の`dialog-modal`はいつでも使用できるより一般的なモーダルウィンドウです。

モーダルの使い方を示すため、以下のような自分のアカウントを削除したいユーザーにモーダルで確認する場合を考えてください。

```html
<jet-confirmation-modal :show="confirmingUserDeletion" @close="confirmingUserDeletion = false">
    <template #title>
        Delete Account
    </template>

    <template #content>
        本当にあなたのアカウントを削除しますか？一度アカウントを削除してしまうと、あなたのリソースとデータは永遠に失われてしまいます。
    </template>

    <template #footer>
        <jet-secondary-button @click.native="confirmingUserDeletion = false">
            Nevermind
        </jet-secondary-button>

        <jet-danger-button class="ml-2" @click.native="deleteTeam" :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
            Delete Account
        </jet-danger-button>
    </template>
</jet-confirmation-modal>
```

ご覧の通り、モーダルのオープン／クローズ状態はコンポーネントが宣言している`show`プロパティにより判定できます。モーダルのコンテンツは、`title`、`content`、`footer`、３つのスロットで指定します。
