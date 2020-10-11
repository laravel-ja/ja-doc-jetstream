# プロファイル管理

[[toc]]

## イントロダクション

Laravel Jetstreamのプロフィール管理機能はユーザーが右上のユーザープロフィールナビのドロップダウンメニューを使いアクセスします。Jetstreamのスカフォールドするビュートアクションは、名前、メールアドレス、その他のオプション、プロフィール写真を更新できるように用意しています。

![Screenshot of Profile Management](./../../assets/img/profile-management.png)

## ビュー／ページ

Livewireスタック使用時は、`resources/views/profile/update-profile-information-form.blade.php` Bladeテンプレートを使い、ビューを表示します。Inertiaスタック使用時は、`resources/js/Pages/Profile/UpdateProfileInformationForm.vue`テンプレートを使い、ビューを表示します。

これらのテンプレートはそれぞれ、必要に応じてフォームに追加のフィールドを増やせるように、認証済みユーザーオブジェクト全体を受け取ります。フォームに追加した入力項目は`UpdateUserProfileInformation`アクションへ渡す`$input`配列に含まれます。

## アクション

Jetstreamの典型的な機能として、ユーザープロフィール更新リクエストを満たすために実行するロジックはアプリケーションのアクションクラスに見ることができます。具体的には、`App\Actions\Fortify\UpdateUserProfileInformation`クラスがユーザープロフィール更新時に実行されます。このアクションは、入力を検証し、ユーザーのプロフィール情報の更新に責務を負います。

そのため、ロジックをカスタマイズしたければ、このクラスを変更します。アクションは現在認証されている`$user`と、存在するなら更新されたプロフィールの写真を含め、受信リクエストの全入力を含む`$input`配列を引数に受け取ります。

## プロファイルの写真

### プロフィール写真の有効化

ユーザーがカスタムプロフィール写真をアップロードできるようにする場合は、`config/jetstream.php`設定ファイルで機能を有効化する必要があります。機能を有効にするには、このファイル内の`features`設定アイテムで、機能のエントリのコメントを外すだけです。

```php
'features' => [
    Features::profilePhotos(),
    Features::api(),
    Features::teams(),
],
```

### プロフィール写真の管理

Jetstreamはデフォルトで、ユーザーのカスタムプロフィール写真のアップロードが可能です。この機能はJetstreamのインストール時に`App\Models\User`クラスへ自動的に追加した、`Laravel\Jetstream\HasProfilePhoto`トレイトがサポートしています。

このトレイトは`updateProfilePhoto`、`getProfilePhotoUrlAttribute`、`defaultProfilePhotoUrl`、`profilePhotoDisk`などのメソッドで構成されており、振る舞いを必要であればカスタマイズできます。アプリケーションへ提供している機能を完全に理解するために、このトレイトのソースコード全体を読むことをおすすめします。

`UpdateUserProfileInformation`アクションが呼び出している、`updateProfilePhoto`メソッドがプロフィール写真を保存しているメインのメソッドです。

:::tip Laravel Vapor

[Laravel Vapor](https://vapor.laravel.com)でアプリケーション実行時は、自動的に`s3`ディスクをデフォルトとして使用します。
:::

## アカウント削除

プロフィール管理スクリーンはそのユーザーがアプリケーションアカウントを削除するためのアクションパネルを用意しています。ユーザーが自身のアカウント削除を選ぶと、`App\Actions\Jetstream\DeleteUser`アクションクラスが実行されます。このクラスにより、アプリケーションアカウントの削除ロジックを自由にカスタマイズできます。
