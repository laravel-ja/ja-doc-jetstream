# チーム

[[toc]]

## イントロダクション

Jetstreamを`--teams`オプション付きでインストールしている場合、アプリケーションにチーム作成と管理をサポートするスカフォールドが作られます。

Jetstreamのチーム機能により、各登録済みユーザーは複数のチームを作成し、所属できます。デフォルトでは、すべての登録ユーザーは「個人(Personal)」チームに属します。たとえば、"Sally Jones"という名前のユーザーが新しいアカウントを作成すると、そのユーザーは`Sally's Team`という名前のチームに割り当てられます。登録後、ユーザーはこのチームの名前を変更するか、追加でチームを作成できます。

![Laravel Jetstreamのスクリーンショット](/img/teams.png)

:::warning Jetstreamチーム

Jetstreamのチームスカフォールドとオプションは、すべてのアプリケーションの要求を満たすものではありません。皆さんのユースケースで役立たない場合は、チームベースではないJetstreamアプリケーションを作成し、チーム機能をアプリケーションへ自分で追加してください。
:::

## チームの作成／削除

右上のユーザーナビにあるドロップダウンメニューから、チーム作成ビューへアクセスできます。

### ビュー／ページ

Livewireスタックの使用時は、`resources/views/teams/create-team-form.blade.php` Bladeテンプレートを使用し、チーム作成ビューを表示します。Inertiaスタックの使用時は、`resources/js/Pages/Teams/CreateTeamForm.vue`テンプレートを使用し、このビューを表示します。

### アクション

チーム作成と削除のロジックは、`app/Actions/Jetstream`ディレクトリの中の関連するアクションクラスを変更することでカスタマイズできます。これらのアクションは`CreateTeam`、`UpdateTeamName`、`DeleteTeam`です。これらのアクションはそれぞれ対応するタスクがアプリケーションのUIでユーザーが実行された時に起動されます。アプリケーションの必要に合わせ、こうしたアクションは自由に変更できます。

## ユーザーチームの調査

ユーザーのチームの情報は、アプリケーションの`Laravel\Jetstream\HasTeams`トレイトが提供するメソッドによりアクセスできます。このトレイトはJetstreamのインストール時に自動的に`App\Models\User`モデルへ適用されます。このトレイトはユーザーのチームを調べるための多種の便利なメソッドを提供します。

```php
// ユーザーが現在選んでいるチームへアクセス
$user->currentTeam : Laravel\Jetstream\Team

// 自分が所属しているものも含めたユーザーが所属してる全チームへアクセス
$user->allTeams() : Illuminate\Support\Collection

// ユーザーが所有するチームへアクセス
$user->ownedTeams : Illuminate\Database\Eloquent\Collection

// 自分で所有していないが、所属してる全チームへアクセス
$user->teams : Illuminate\Database\Eloquent\Collection

// ユーザーの「個人的」なチームへアクセス
$user->personalTeam() : Laravel\Jetstream\Team

// Determine if a user owns a given team...
$user->ownsTeam($team) : bool

// ユーザーが指定したチームを所有しているか判定
$user->belongsToTeam($team) : bool

// ユーザーがそのチームでアサインされているロールを取得
$user->teamRole($team) : \Laravel\Jetstream\Role

// ユーザーが指定チームの指定ロールを持っているか判定
$user->hasTeamRole($team, 'admin') : bool

// ユーザーが指定したチームへ持っている全パーミッションのリスト
$user->teamPermissions($team) : array

// ユーザーが指定パーミンションを持っているか判定
$user->hasTeamPermission($team, 'server:create') : bool
```

### 現在のチーム

Jetstreamアプリケーションの中ではすべてのユーザーが「現在のチーム」を持っています。これはそのユーザーが積極的にリソースを閲覧しているチームのことです。たとえば、カレンダーアプリケーションを構築中であれば、あなたのアプリケーションは現在のチームのユーザーによるカレンダーイベントのうち、これから行うものを表示したいでしょう。

`$user->currentTeam` Eloquentリレーションを使用すれば、ユーザーの現在のチームへアクセスできます。このチームは他のEloquentクエリをチームでスコープするために使用できます。

```php
return App\Models\Calendar::where(
    'team_id', $request->user()->currentTeam->id
)->get();
```

ユーザーはJetstreamのナビバーの中から使用できるユーザープロフィールのドロップダウンメニューにより、現在のチームを切り替えできます。

![Screenshot of Team Switcher](./../../assets/img/team-switcher.png)

### チームオブジェクト

チームオブジェクトへは`$user->currentTeam`、もしくはチームの属性とリレーションを調べるための便利なメソッドを各種提供しているEloquentクエリによりアクセスできます。

```php
// チームのオーナへアクセス
$team->owner : \App\Models\User

// オーナーも含むチームの全ユーザーの取得
$team->allUsers() : Illuminate\Database\Eloquent\Collection

// オーナーを除く、チームの全ユーザーの取得
$team->users : Illuminate\Database\Eloquent\Collection

// 指定ユーザーがチームのメンバーであるか判定
$team->hasUser($user) : bool

// 指定したメールアドレスのメンバーがチームに所属しているか判定
$team->hasUserWithEmail($emailAddress) : bool

// 指定したユーザーが指定したパーミッションを持ったチームメンバーであるか判定
$team->userHasPermission($user, $permission) : bool
```

## メンバー管理

チームメンバーはJetstreamの「チーム設定」ビューで追加と削除ができます。これらのアクションを管理するバックエンドのロジックは、`App\Actions\Jetstream\AddTeamMember`クラスのような関連するアクションを変更することでカスタマイズできます。

### メンバー管理ビュー／ページ

Livewireスタック使用時は、チームメンバー管理ビューを`resources/views/teams/team-member-manager.blade.php` Bladeテンプレートを使用し表示します。Inertiaスタック使用時は、`resources/js/Pages/Teams/TeamMemberManager.vue`テンプレートを使用してこのビューを表示します。一般的に、これらのテンプレートはカスタマイズすべきでないでしょう。

### メンバー管理アクション

メンバーの追加ロジックは`App\Actions\Jetstream\AddTeamMember`アクションクラスを変更してカスタマイズします。このクラスの`add`メソッドは現在の認証済みユーザー、`Laravel\Jetstream\Team`インスタンス、チームへ追加するユーザーのメールアドレスとロール（使用時）を渡され、起動されます。

このアクションは実際にユーザーをチームへ追加できるのかを検証し、よければ追加する責務を持っています。アプリケーションの必要に応じ、このアクションを自由にカスタマイズしてください。

### ロール／パーミッション

各チームメンバーは指定ロールを割り当てて、チームに追加します。割り付ける各ロールは１組のパーミッションです。ロールパーミッションはアプリケーションの`JetstreamServiceProvider`で、`Jetstream::role`メソッドを使用して定義します。このメソッドはロールごとに「スラグ」、ユーザーフレンドリーなロール名、ロールパーミッション、ロールの説明を引数に取ります。この情報はチームメンバー管理ビューの中にロールを表示するために使用します。

```php
Jetstream::defaultApiTokenPermissions(['read']);

Jetstream::role('admin', 'Administrator', [
    'create',
    'read',
    'update',
    'delete',
])->description('Administrator users can perform any action.');

Jetstream::role('editor', 'Editor', [
    'read',
    'create',
    'update',
])->description('Editor users have the ability to read, create, and update.');
```

:::tip チームAPIサポート

チームサポートを指定しJetstreamをインストールすると、ロールで利用可能な一意のパーミッションのすべての組み合わせとして、APIパーミッションを自動的に利用可能にします。そのため、`Jetstream::permissions`メソッドを個別に呼び出す必要はありません。
:::

### 認可

もちろんチームメンバーが発信したリクエストを受信したら、そのユーザーが実際に実行できるのかを認可する方法が必要になります。ユーザーのチームパーミッションは`Laravel\Jetstream\HasTeams`トレイトによる`hasTeamPermission`メソッドを使用し確認します。ユーザーのロールを検証する必要はまったくありません。そのユーザーが指定している粒度のパーミッションを持っていることを確認する必要があるだけです。ロールはパーミッションの粒度をグループ化するために使用する表現的な概念に過ぎません。通常は、アプリケーションの[許可ポリシー](https://laravel.com/docs/authorization)の中で、このメソッドを呼び出します。

```php
if ($request->user()->hasTeamPermission($team, 'read')) {
    // ユーザーは"read"パーミッションを含むロールを持っている
}
```

#### チームパーミッションとAPIパーミッションを組み合わせる

APIサポートとチームサポートの両者を提供するJetstreamアプリケーションの構築時、受信リクエストのチームパーミッションとAPIトークンパーミッションの「両方」をアプリケーションの認可ポリシーの中で検証しなくてはなりません。APIトークンにはアクションを実行する理論上のアビリティがあるかもしれませんが、ユーザーはチームパーミッションによりそのアクションを実行する権限を付与されているとは限らないため、これは重要です。

```php
/**
 * ユーザーがフライトを観ることができるかを決める
 *
 * @param  \App\Models\User  $user
 * @param  \App\Models\Flight  $flight
 * @return bool
 */
public function view(User $user, Flight $flight)
{
    return $user->belongsToTeam($flight->team) &&
           $user->hasTeamPermission($flight->team, 'flight:view') &&
           $user->tokenCan('flight:view');
}
```
