# イントロダクション

[[toc]]

## Laravel Jetstream

Laravel （ジェットストリーム：ジェット気流）は、Laravelのためのに美しくデザインされたアプリケーションのスカフォールドです。ログイン、ユーザー登録、メール確認、２要素認証、セッション管理、[Laravel Sanctum](https://github.com/laravel/sanctum)を使ったAPI、オプションとしてチーム管理を含んだ、次のLaravelアプリケーションの完璧なスタートポイントを提供します。

JetstreamはTailwind CSSを使用しデザインしており、[Livewire](./stacks/livewire.md)か[Inertia](./stacks/inertia.md)の使用を選択していただけます。

![Screenshot of Laravel Jetstream](./../assets/img/preview.png)

## 利用可能スタック

Laravel Jetstreamはフロントエンドスタックとして２つの選択肢を提供します。[Livewire](https://laravel-livewire.com)と[Inertia.js](https://inertiajs.com)です。各スタックは生産性が高く、パワフルなアプリケーション構築のスタートポイントです。スタックの選択はテンプレートの言語に好みによります。

### Livewire＋Blade

Laravel Livewireはテンプレート言語としてLaravel Bladeを使い、モダンでリアクティブ、動的なインターフェイスを簡単に構築できるライブラリです。このスタックは動的でリアクティブなアプリケーションを構築したいが、Vue.jsのようなフルJavaScriptフレームワークへ飛び込むことへは躊躇する場合に、良い選択です。

Livewireを使用する場合、アプリケーションのどの部分をLivewireコンポーネントにするかを選ぶことになりますが、アプリケーションの残りの部分は、今まで使ってきたトラディショナルなBladeテンプレートでレンダーされます。

:::tip Livewireスクリーンキャスト

Livewireがはじめてでしたら、[screencasts available on the Livewireのサイトに用意されているスクリーンキャスト](https://laravel-livewire.com/screencasts/installation)（英語）をチェックしてみてください。
:::

### Inertia.js＋Vue

Jetstreamが提供しているInertia.jsスタックは、テンプレート言語として[Vue.js](https://vuejs.org)を使います。Inertiaアプリケーションの構築は、多くの部分が典型的なVueアプリケーションの構築と似ています。しかし、Vueのルータの代わりにLaravelのルータを使います。InertiaはLaravelコンポーネントデータの名前を提供することにより、LaravelのバックエンドからVueコンポーネントの単一ファイルをレンダーできるようにする小さなライブラリーです。データはコンポーネントの"props"へ受け渡します。

言い換えればこのスタックは、複雑なクライアントサイドのルーティングを使用せず、Vue.jsのフルパワーを提供します。今まで使ってきたLaravelの標準ルータが使用できます。

Inertiaスタックは、Vue.jsをテンプレート言語として使用するのに慣れており、楽しんでいる場合に良い選択肢です。


