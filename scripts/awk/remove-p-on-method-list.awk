#!/bin/awk

/collection-method-list/ {
    print $0;

    while (getline > 0) {
        if ($0 ~ /<\/div>/) {
            break;
        }
        gsub("<p>", "");
        gsub("</p>", "");
        print $0;
    }

    print $0;
    next;
}

{
    print $0;
}
