#!/bin/bash 

function lsext()
{
find . -type f -iname '*.'${1}'' -exec ls -l {} \; ;
}
