#!/bin/awk

# []()の列挙をPandocが一行に接続してしまうため、分割する

{
    gsub(/<\/a> <a/, "</a>\n<a");
    print $0;
}
