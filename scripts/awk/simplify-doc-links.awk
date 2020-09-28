#!/bin/bash

/\/?docs\//{

    # 以下の２行の記述方法はMint/Ubuntuでは使えない
    # 置換関数の後方参照は全部まともに動かない
    # $0 = gensub(/\/?docs(\/[[:alnum:]\._-]+)*\/([[:alnum:]\._-]+)(#.*)?"/, "\\2.html\\3\"", "G");
    # $0 = gensub(/\/?docs\/{{version}}\/([[:alnum:]\._-]+)(#.*)?"/, "\\1.html\\2\"", "G");

    # バージョン4.2までの対応
    gsub(/\/?docs\/4\.2\/([[:alnum:]\._-])+/, "&.html")
    gsub(/\/?docs\/4\.2\//, "")

    # バージョン5.0以降の{{version}}対応
    gsub(/{{version}}\/[[:alnum:]\._-]+/, "&.html")
    gsub(/\/?docs\/{{version}}\//, "")
}

{
    print $0;
}
