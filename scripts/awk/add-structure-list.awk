#!/bin/awk

BEGIN {
    match(original_file, /laravel(\/([[:digit:]]+\.([[:digit:]]+|dev|x))(\/(en|ja))?)?\/(([[:alnum:]]+)\.html)/, matched);
       version = matched[2];
       lang =  matched[5];
       file_name = matched[6];
       base_name = matched[7];
}

/<h1>/ {
    match($0, /<h1>(.+)<\/h1>/, matched);
    header_1 = matched[1];
}

/<\/body>/ {
# 構造化データ
    # サイト情報
    print "<script type=\"application/ld+json\">"
    print "{"
    print "  \"@context\": \"http://schema.org\","
    print "  \"@type\": \"WebSite\","
    print "  \"name\": \"Readouble\","
    print "  \"url\": \"https://readouble.com\""
    # laravel/index.htmlの場合、一致しないためfile_nameは空
    if (file_name == "") {
        print ","
        print "  \"potentialAction\": {"
        print "    \"@type\": \"SearchAction\","
        print "    \"target\": \"https://readouble.com/search?q={search_term_string}\","
        print "    \"query-input\": \"required name=search_term_string\""
        print "  }"
    }
    print "}"
    print "</script>"
    # Google検索のパンくずリスト情報
    # laravel/index.html以外の場合はfile_nameが存在する。
    if (file_name != "") {
        # laravel
        # プロジェクト名
        print "<script type=\"application/ld+json\">"
        print "{"
        print "\"@context\": \"http://schema.org\","
        print "\"@type\": \"BreadcrumbList\","
        print "\"itemListElement\": ["
        print "{"
        print "  \"@type\": \"ListItem\","
        print "  \"position\": 1,"
        print "  \"item\": {"
        print "    \"@id\": \"https://readouble.com/laravel\","
        print "    \"name\": \"Laravel\""
        print "  }"
        print "}"
    }
    # laravel/5.5/index.html
    # バージョン
    if (version != "") {
        print ","
        print "{"
        print "  \"@type\": \"ListItem\","
        print "  \"position\": 2,"
        print "  \"item\": {"
        print "    \"@id\": \"https://readouble.com/laravel/" version "\","
        print "    \"name\": \"Ver." version "\""
        print "  }"
        print "}"
    }
    # laravel/5.5/ja...
    # 言語
    if (lang != "") {
        if (lang == "ja") {
            lg = "日本語"
        } else {
            lg = "English"
        }
        print ","
        print "{"
        print "  \"@type\": \"ListItem\","
        print "  \"position\": 3,"
        print "  \"item\": {"
        print "    \"@id\": \"https://readouble.com/laravel/" version "/" lang "\","
        print "    \"name\": \"" lg "\""
        print "  }"
        print "}"
    }
    # laravel/5.5/ja/collections.html
    # タイトル
    if (lang != "" && file_name != "" && file_name != "index.html") {
        print ","
        print "{"
        print "  \"@type\": \"ListItem\","
        print "  \"position\": 4,"
        print "  \"item\": {"
        print "    \"@id\": \"https://readouble.com/laravel/" version "/" lang "/" base_name "\","
        print "    \"name\": \"" header_1 "\""
        print "  }"
        print "}"
    }
    # 閉じ括弧・閉じタグ
    # laravel/index.html以外
    if (file_name != "") {
        print "]}"
        print "</script>";
   }
}

{
    print $0;
}
