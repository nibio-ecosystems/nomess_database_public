#!/bin/bash

make clean
make -j 32 1>std.out 2>err.out
