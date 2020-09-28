#!/bin/awk

BEGIN {
    #                       > version                      <    >lang<        > base_name <
    match(original_file, /(\/([[:digit:]]+\.([[:digit:]]+|dev|x))(\/(en|ja))?)?\/([[:alnum:]-]+)\./, matched );

    version = matched[2];
    lang   = matched[5];
    base_name = matched[6];

    while ((getline < converted_file) > 0) {

        # ここはhtmlに変換されたファイルの内容がテンプレートに影響を与えるロジックのみ記述する
        # 個別の変換ロジックは記述しない

        # <h1>からのH2、H3タグへのリンクを削除する
        if (version != "" && lang != "" && base_name != "index") {

            # h1タグはタイトルに流用しつつ、トップバーに設定する
            if ($0 ~ /<h1>.+<\/h1>/) {
                match($0, /<h1>(.+)<\/h1>/, matched);
                title = matched[1];
                gsub(/&/, "\\\\&", title);
                anchorParts = "true";
                continue;
            }

            if ($0 ~ /[[:blank:]]*?<a[[:blank:]]+?name=.+?<\/a>/) {
                anchorParts = "false";
            }

            # 冒頭のアンカーパート削除
            if (anchorParts == "true") {
                continue;
            }
        }

        content[content_line++] = $0;
    }
}

/{{ content }}/ {
    for (i=0; i < content_line; i++) {
        print content[i];
    }

    next;
}

{
    # テンプレートを読みながら処理

    gsub(/{{ title }}/, title);

    # テンプレート中のAPIリンクのみ個別で対応
    gsub(/{{version}}.html/, "https://laravel.com/api/" version);
    gsub(/6\.x\.html/, "https://laravel.com/api/6.x");

    print $0;
}
