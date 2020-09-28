#!/bin/awk

/<style>/ {
    in_style = "true";
    next;
}

/<\/style>/ {
    in_style = "false";
    next;
}

in_style == "true" {
    next;
}

{
    print $0;
}
