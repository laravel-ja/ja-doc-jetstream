#!/bin/awk

BEGIN {
    # バージョンの取得
    match(header_file, /\/([[:digit:]]+\.([[:digit:]]+|dev|x))\//, matched);
    version = matched[1];

    # 言語の取得
    match(header_file, /(\/en\/|\/ja\/)/, matched);
    lang = matched[1];
    gsub(/\//, "", lang);

    # ヘッダーファイルの読み込み
    getline header < header_file;
    close(header_file);

    # フッターファイルの読み込み
    getline footer < footer_file;
    close(footer_file);

    # 英語版には、最新ではないことを留意してもらう
    if (lang == "en") {
        footer = "English pages are hosted to show original documentations for Japanese translations. Notice they are not the latest. If you want the latest, please read official pages</a>.<br>" footer;
    }

    # エンティティが置換されないように、エスケープする
    gsub(/&/, "\\\\&", footer);

    # documentation.mdファイルの読み込み
    if (doc_file != "none") {
        while (getline < doc_file > 0) {

            if ($0 ~ /^- /) {
                # 第１レベル処理
                if (first == "false") {
                    doc[doc_line++] = "                </div>"
                    doc[doc_line++] = "            </div>"
                    doc[doc_line++] = "        </div>"
                }
                first = "false";

                sub(/#+/, "");;
                sub(/^- +/, "");
                doc[doc_line++] = "        <div class=\"categoryBlock\">";
                doc[doc_line++] = "             <div class=\"categoryName\">" $0 "</div>";
                doc[doc_line++] = "             <div class=\"documentPages\">";
                doc[doc_line++] = "                 <div class=\"chapters\">";
            } else if ($0 ~ /^ +- /) {
                # 第２レベル処理
                match($0, /\[(.+)\].+\/(.+)\)$/, matched);

                if ($0 ~ /\/api\//) {
                    doc[doc_line++] = "                     <a href=\"https://laravel.com/api/" matched[2] "\">" matched[1] "</a>";
                } else {
                    doc[doc_line++] = "                     <a href=\"" matched[2] ".html\">" matched[1] "</a>";
                }
            }
        }
        close(doc_file);
        while(getline < append_file > 0) {
            doc[doc_line++] = $0;
        }
        doc[doc_line++] = "                </div>"
        doc[doc_line++] = "            </div>"
        doc[doc_line++] = "        </div>"
    }

}

# templates/base-template.htmlを１行ずつ処理

/{{ chapters }}/ {
    if (doc_file != "none") {
        for (i=0; i < doc_line; i++) {
            print doc[i];
        }

        next;
    }
}

{
    gsub(/{{ page-title }}/, header " " version " {{ title }}");
    gsub(/{{ header-title }}/, "{{ title }} " version " " header);
    gsub(/{{ footer }}/, footer);

    print $0;
}
