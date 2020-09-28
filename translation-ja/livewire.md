# Livewire

[[toc]]

## イントロダクション

Laravel LivewireはBladeをテンプレート言語として使用した、モダンなリアクティブで動的なインターフェースを簡単に構築できるようにするライブラリです。これは動的でリアクティブなアプリケーションを構築したいが、Vue.jsのようなJavaScriptフレームワークへ完全に飛び込むことに抵抗がある場合に選択するのに最適なスタックです。

Livewireの使用時、アプリケーションのルートは通常のBladeテンプレートで対応します。ただし、これらのテンプレート内で必要に応じ、Livewireコンポーネントをレンダーできます。

```html
<div class="mt-4">
    @livewire('server-list')
</div>
```

Livewireスタックの使用時、認識しておくべきJetstreamのユニークな機能があります。以降でこうした機能を説明します。

:::tip Livewireドキュメント

Livewireスタックを使用する前に、[Livewireドキュメント](https://laravel-livewire.com)全体を確認しておくことを強くおすすめします。
:::

## コンポーネント

JetstreamのLivewireスタックで構築するとき、UIの一貫性を支援し使いやすくするため、さまざまなBladeコンポーネント（ボタン、パネル、入力、モーダル）を作成します。これらのコンポーネントは使用するもしないも自由です。使用する場合は、Artisanの `vendor：publish`コマンドを使用してリソースを公開する必要があります。

```bash
php artisan vendor:publish --tag=jetstream-views
```

`resources / views`ディレクトリ内にあるJetstreamの既存のビュー内で使い方を確認すれば、これらのコンポーネントの使用方法についての洞察を得られるでしょう。

## モーダル

ほとんどのJetstream Livewireスタックのコンポーネントは、バックエンドと通信しません。ただし、Jetstreamに含まれているLivewireモーダルコンポーネントは、Livewireバックエンドとやり取りして、オープン/クローズ状態を判断しています。また、Jetstreamは、`dialog-modal`と`confirmation-modal`の２種類のモーダルを用意しています。`confirmation-modal`は削除など破壊的なアクションを確認するときに使用しますが、一方の`dialog-modal`はいつでも使用できるより一般的なモーダルウィンドウです。

モーダルの使い方を示すため、以下のような自分のアカウントを削除したいユーザーにモーダルで確認する場合を考えてください。

```html
<x-jet-confirmation-modal wire:model="confirmingUserDeletion">
    <x-slot name="title">
        Delete Account
    </x-slot>

    <x-slot name="content">
        本当にあなたのアカウントを削除しますか？一度アカウントを削除してしまうと、あなたのリソースとデータは永遠に失われてしまいます。
    </x-slot>

    <x-slot name="footer">
        <x-jet-secondary-button wire:click="$toggle('confirmingUserDeletion')" wire:loading.attr="disabled">
            Nevermind
        </x-jet-secondary-button>

        <x-jet-danger-button class="ml-2" wire:click="deleteUser" wire:loading.attr="disabled">
            Delete Account
        </x-jet-danger-button>
    </x-slot>
</x-jet-confirmation-modal>
```

ご覧の通り、モーダルのオープン／クローズ状態はコンポーネントで宣言されている`wire:model`プロパティで判断できます。このプロパティ名はLivewireコンポーネントの対応するPHPクラスの論理値プロパティと対応させる必要があります。モーダルのコンテンツは、`title`、`content`、`footer`、３つのスロットで指定します。
