#!/usr/bin/env python3

import sys
import os

def get_candidates(git_dir, colon_path):
    if not colon_path.startswith(':/'):
        raise Exception("colon_path needs to start with :/")

    path = colon_path[2:]
    print(f"path = {path}",file=sys.stderr)
    if path.endswith('/') or path == "":
        abspath = os.path.join(git_dir, path)
        # print(f"abspath = {abspath}")
    abspath = os.path.join(git_dir, os.path.dirname(path))
    print(f"abspath = {abspath}", file=sys.stderr)
    all_files = os.listdir(abspath)
    # print(f"all_files = {all_files}")
    dirs = []
    print(f"all_files = {all_files}", file=sys.stderr)
    abs_all_files = list(map(lambda p: os.path.join(abspath, p), all_files))
    main_dirs = list(filter(os.path.isdir, abs_all_files))
    dirs += main_dirs
    print(f"\033[1;33mmain_dirs = {main_dirs}\033[0m", file=sys.stderr)
    for d in main_dirs:
        print(f"d = {d}", file=sys.stderr)
        subdir_basenames = os.listdir(d)
        abs_subdirs = list(map(lambda p: os.path.join(d,p), subdir_basenames))
        subdirs = list(filter(os.path.isdir, abs_subdirs))
        dirs += subdirs
    print(f"\033[1;32mdirs = {dirs}\033[0m", file=sys.stderr)
    colon_dirs = list(map(lambda d: f":/{d[len(git_dir)+1:]}", dirs))
    # print(f"dirs = {dirs}")
    print(f"colon_dirs = {colon_dirs}", file=sys.stderr)
    for d in colon_dirs:
            print(d+'/')
    return


if __name__ == "__main__":
    get_candidates(sys.argv[1], sys.argv[2])
