#! /bin/bash

########################################
# Render .org notes files to HTML tree #
########################################

MCRUN_PROJECT_ROOT="${HOME}/Projects"
MCRUN_ACTIVE_PROJECTS=("CSD" "ZAO")
MCRUN_CSS="$(dirname $0)/../src/org.css"
MCRUN_HTML_STORE="${HOME}/Desktop/test"

function main () {
    for PROJECT in ${MCRUN_ACTIVE_PROJECTS[@]}
    do
        pushd ${MCRUN_PROJECT_ROOT}/${PROJECT}
        mkdir ${MCRUN_HTML_STORE}/${PROJECT}
        for FILE in $(find . -name "*.org")
        do
            local FILE_REL_PATH=$(dirname "${FILE}" | cut -c 2-)
            local FILE_BASE_NAME=$(basename "${FILE}" .org)
            local HTML_ABS_PATH="${MCRUN_HTML_STORE}/${PROJECT}""${FILE_REL_PATH}"
            mkdir -p "${HTML_ABS_PATH}"
            pushd ".${FILE_REL_PATH}"
            mcrun-convert-to-html "${FILE_BASE_NAME}".org "${HTML_ABS_PATH}/${FILE_BASE_NAME}.html"
            popd
        done
        popd
    done
}

function mcrun-convert-to-html () {
    # Convert a .org file to self-contained HTML
    # Usage: mcrun-convert-to-html SOURCE.ORG DESTINATION.HTML
    echo "Calling mcrun-convert-to-html with args" $1 $2
    FILENAME=$(basename $1);
    DIRNAME=$(dirname $1);
    pushd ${DIRNAME};
        org-convert-to-html ${FILENAME};
        pandoc -i "$(basename $FILENAME .org).html" -c ${MCRUN_CSS} --self-contained -o "$2";
    popd
}

function org-convert-to-html () {
    emacs --batch --eval "(progn (find-file \"$1\") 
                                 (org-html-export-to-html))"
}

main
