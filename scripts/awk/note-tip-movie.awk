#!/bin/awk
{
    # 5.3から追加された{note}、{tip}、{video}の処理
    sub(/{note}/, "<i class=\"icon-doc-text\"></i>Note: ");
    sub(/{tip}/, "<i class=\"icon-lightbulb\"></i>Tip!! ");
    sub(/{video}/, "<i class=\"icon-video\"></i>");

    print $0;
}
