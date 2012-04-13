sys "git clean -x -f -- public/stylesheets public/javascripts"  # clear cached assets (unversioned/ignored files)
sys "git clean -d -f -- vendor/plugins"                         # clean unversioned files from vendor/plugins (e.g. old submodules)
