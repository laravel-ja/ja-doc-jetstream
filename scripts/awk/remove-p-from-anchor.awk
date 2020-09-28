#!/bin/awk

# h2からh4タグの直前にあるアンカーの、pタグを取り去る。
# これが残っていると、余計な一行が表示される。

/<p><a/ {
    match($0, /<p[[:blank:]]*?>[[:blank:]]*?(<a[[:blank:]]+?name=".+?"><\/a>)<\/p>/, matched);
    anchor = matched[1];
    original = $0;

    if (getline > 0) {
        if ($0 ~ /h[234]/) {
            print anchor;
        } else {
            print original;
        }
    } else {
        print original;
        exit;
    }
}

{
    print $0;
}
