#!/bin/awk

# ver コマンドラインから渡されるバージョン

BEGIN {
    print "# Laravel", ver, "TOC";
}

/^- / {
    gsub(/^- #+/, "- ");
    gsub(/^- /, "## ");
    print "";
    print $0;
    print "";

    next;
}

{
    #　この変換結果は/markdowns/..../index.mdにのみ反映
    gsub(/^[ ]+- /, "- ");
    gsub(/\/docs\/{{version}}\/[^)]+/, "&.html");
    gsub(/\/docs\/{{version}}\//, "");

    # apiのURLリンクはバージョンにより異なる。
    gsub("/api/{{version}}",  "https://laravel.com/api/" ver);
    gsub("/api/",  "https://laravel.com/api/");
    print $0;
}

END {
    appendix_section = gensub("markdowns", "templates", "1", dir) "/append-index.md"

    print ""

    while((getline < appendix_section ) > 0) {
        print $0;
    }
}
