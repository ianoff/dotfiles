alias fontbook="open -b com.apple.FontBook"
zipdir="./unzipped"

function install_fonts() {    
    [ ! -d "$zipdir" ] && mkdir -p "$zipdir";
    unzip -uj \*.zip \*.otf  -d "$zipdir";
    open "~/Library/Fonts/"
}

function clean_fonts() {
    rm -r $zipdir;
}