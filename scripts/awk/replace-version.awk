#!/bin/bash

# 変換しきれなかったバージョン指定を変換する
# これは最後の後処理にする

BEGIN {
    match(original_file, /\/([[:digit:]]+\.([[:digit:]]+|dev|x))\//, matched );

    version = matched[1];
}

{
    # {{version}}はエスケープ済み
    gsub(/%7B%7Bversion%7D%7D/, version);
    print $0;
}
