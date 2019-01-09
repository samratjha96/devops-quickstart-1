#!/usr/bin/env bash

CURRENT_DIR=`dirname $0`

# Colors and styling for the command line
DIM='\033[2m'
BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE='\033[1;37m'
CHECK='\xE2\x9C\x94'
BLACK_ON_GREY='\033[30;47m'
RESET='\033[0m'

WELCOME_MSG="
This is an Appian-provided macOS command line tool that will help configure a sample pipeline for use"

ADM_MSG="
┌------------------- ADM Configuration ---------------------┐
|    Let's configure the ADM tools for use (AIM and AVM).   |
|    The prerequisite is that you must have a AVM built     |
|    application residing in the appian/applications folder |
└-----------------------------------------------------------┘
"

FITNESSE_MSG="
┌------------------- FitNesse Configuration ----------------┐
|    Let's configure the FitNesse properties and tests.     |
|    The prerequisite is that you must have at least one    |
|    Appian site running.                                   |
└-----------------------------------------------------------┘
"

Integration_stage="
┌-----------------------------------------------------------┐
|              INTEGRATION TEST CONFIGURATION               |
└-----------------------------------------------------------┘
"

Acceptance_stage="
┌-----------------------------------------------------------┐
|              ACCEPTANCE TEST CONFIGURATION                |
└-----------------------------------------------------------┘
"

main() {
  setup_window

  echo -e "\\n${BOLD}${ADM_MSG}${RESET}\\n"
  import_manager_prompts
  version_manager_prompts
  echo -e "\\n${BOLD}${FITNESSE_MSG}${RESET}"
  fitnesse_prompts
  goodbye_message
  echo -e "\\n"
  exit 0;
}

# Print ASCII art
base64_print() {
  printf  "%s" "$@" | base64 --decode
}

setup_window() {
  # Resize the window and clear the screen
  printf '\e[8;50;125t'; printf "\\033c"
  # some ascii art
  printf "\\e[38;5;196m"; base64_print CiAgICAgICAgICAgICAgICAgICAgICAgXyAgICAgICAgICAgICAgIF9fX19fICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgIC9cICAgICAgICAgICAgICAgKF8pICAgICAgICAgICAgIHwgIF9fIFwgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgIC8gIFwgICBfIF9fICBfIF9fICBfICBfXyBfIF8gX18gICB8IHwgIHwgfCBfX19fXyAgIF9fX19fICBfIF9fICBfX18gCiAgIC8gL1wgXCB8ICdfIFx8ICdfIFx8IHwvIF9gIHwgJ18gXCAgfCB8ICB8IHwvIF8gXCBcIC8gLyBfIFx8ICdfIFwvIF9ffAogIC8gX19fXyBcfCB8XykgfCB8XykgfCB8IChffCB8IHwgfCB8IHwgfF9ffCB8ICBfXy9cIFYgLyAoXykgfCB8XykgXF9fIFwKIC9fLyAgICBcX1wgLl9fL3wgLl9fL3xffFxfXyxffF98IHxffCB8X19fX18vIFxfX198IFxfLyBcX19fL3wgLl9fL3xfX18vCiAgICAgICAgICB8IHwgICB8IHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8IHwgICAgICAgIAogICAgICAgICAgfF98ICAgfF98ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfF98ICAgICAgICAK
  printf "\\e[38;5;27m"; base64_print CiAgICBfX18gXyAgICAgICAgICAgIF8gXyAgICAgICAgICAgICAgX19fX18gICAgICAgICAgICBfIAogICAvIF8gKF8pXyBfXyAgIF9fX3wgKF8pXyBfXyAgIF9fXyAgL19fICAgXF9fXyAgIF9fXyB8IHwKICAvIC9fKS8gfCAnXyBcIC8gXyBcIHwgfCAnXyBcIC8gXyBcICAgLyAvXC8gXyBcIC8gXyBcfCB8CiAvIF9fXy98IHwgfF8pIHwgIF9fLyB8IHwgfCB8IHwgIF9fLyAgLyAvIHwgKF8pIHwgKF8pIHwgfAogXC8gICAgfF98IC5fXy8gXF9fX3xffF98X3wgfF98XF9fX3wgIFwvICAgXF9fXy8gXF9fXy98X3wKICAgICAgICAgfF98ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCg==
  printf "\\e[0m"; printf '\n'
  echo -e "${BOLD}${WELCOME_MSG}${RESET}\\n"
}

import_manager_prompts() {
  TEST_IMPORT_PROPERTIES=$CURRENT_DIR/devops/adm/import-manager.test.properties
  STAG_IMPORT_PROPERTIES=$CURRENT_DIR/devops/adm/import-manager.stag.properties
  PROD_IMPORT_PROPERTIES=$CURRENT_DIR/devops/adm/import-manager.prod.properties

  # Read in the URL's of all the environments
  read -p "$(echo -e $WHITE)Enter URL of your test environment (ending with /suite):$(echo -e $RESET) " TEST_URL
  echo -e "\\n${BLACK_ON_GREY}Modified $TEST_IMPORT_PROPERTIES with the given url${RESET}\\n"
  read -p "$(echo -e $WHITE)Enter URL of your staging environment (ending with /suite):$(echo -e $RESET) " STAG_URL
  echo -e "\\n${BLACK_ON_GREY}Modified $STAG_IMPORT_PROPERTIES with the given url${RESET}\\n"
  read -p "$(echo -e $WHITE)Enter URL of your production environment (ending with /suite):$(echo -e $RESET) " PROD_URL
  echo -e "\\n${BLACK_ON_GREY}Modified $PROD_IMPORT_PROPERTIES with the given url${RESET}\\n"

  # Configure import manager properties files with the given site URL's (only if non-empty)
  if [[ $TEST_URL ]]; then
    sed-populate-field "url" "$TEST_URL" $TEST_IMPORT_PROPERTIES
  fi
  if [[ $STAG_URL ]]; then
    sed-populate-field "url" "$STAG_URL" $STAG_IMPORT_PROPERTIES
  fi
  if [[ $PROD_URL ]]; then
    sed-populate-field "url" "$PROD_URL" $PROD_IMPORT_PROPERTIES
  fi
}

version_manager_prompts() {
  VERSION_MANAGER_PROPERTIES=$CURRENT_DIR/devops/adm/version-manager.properties

  echo -e "\\n${BLACK_ON_GREY}Modifying $VERSION_MANAGER_PROPERTIES with the following prompts${RESET}\\n"
  read -p "$(echo -e $WHITE)Enter your repo URL (repo where you want to version your applications):$(echo -e $RESET) " REPO_URL
  read -p "$(echo -e $WHITE)Enter a folder name where you want this repo to be cloned (ex: staging):$(echo -e $RESET) " LOCAL_REPO
  read -p "$(echo -e $WHITE)Enter a name of the branch you want to clone from your repo (Default is master):$(echo -e $RESET) " BRANCH_NAME

  # Configure version manager properties file with the given inputs (only if non-empty)
  if [[ $REPO_URL ]]; then
    sed-populate-field "repoUrl" "$REPO_URL" $VERSION_MANAGER_PROPERTIES
  fi
  if [[ $LOCAL_REPO ]]; then
    sed-populate-field "localRepoPath" "$LOCAL_REPO" $VERSION_MANAGER_PROPERTIES
  fi
  if [[ $BRANCH_NAME ]]; then
    sed-populate-field "branchName" "$BRANCH_NAME" $VERSION_MANAGER_PROPERTIES
  fi
}

fitnesse_prompts() {
  users_properties=$CURRENT_DIR/devops/f4a/users.properties
  acceptance_test=$CURRENT_DIR/devops/f4a/test_suites/QuickStartAcceptanceTest/content.txt
  integration_test=$CURRENT_DIR/devops/f4a/test_suites/QuickStartIntegrationTest/content.txt

  for i in `seq 1 2`; do
    if [ $i -eq 1 ]; then
      current_test=$integration_test
      in_echoes="Integration"
      stage_msg="${Integration_stage}"
    else
      current_test=$acceptance_test
      in_echoes="Acceptance"
      stage_msg="${Acceptance_stage}"
    fi
    echo -e "${BOLD}${stage_msg}${RESET}\\n"
    read -p "$(echo -e $RED)Press enter to edit the ${in_echoes} Test:$(echo -e $RESET) "
    cat $current_test
    # TODO: Input validation
    echo -e "${WHITE}Pick one of the following browsers:\\n
      1. CHROME\\n
      2. FIREFOX\\n
      3. REMOTE_FIREFOX\\n
      4. REMOTE_CHROME\\n"

    read -p "(recommended REMOTE_FIREFOX or REMOTE_CHROME):$(echo -e $RESET) " TST_BROWSER
    read -p "$(echo -e $WHITE)Enter the url for the Appian site you want to test (ending with /suite):$(echo -e $RESET) " TST_SITE_URL
    read -p "$(echo -e $WHITE)Enter the version of this Appian site:$(echo -e $RESET) " TST_SITE_VERSION
    read -p "$(echo -e $WHITE)Enter the locale of this Appian site (en_US or en_GB):$(echo -e $RESET) " TST_SITE_LOCALE
    read -p "$(echo -e $WHITE)Enter the username for this Appian site:$(echo -e $RESET) " TST_SITE_USR

    # Check if the specified user already has an entry in the users.properties file
    if grep -Fq "$TST_SITE_USR=" $users_properties; then
      : # Do nothing if user has entry in the users.properties file
    else
      # TODO: Make a check that username/password isn't null
      read -s -p "$(echo -e $WHITE)Enter the password for this user:$(echo -e $RESET) " TST_USR_PASSWORD
      user_password_pair="$TST_SITE_USR=$TST_USR_PASSWORD"
      echo $user_password_pair >> $users_properties
    fi
    if [[ $TST_BROWSER ]]; then
      sed-replace-in-FitNesse "BROWSER" $TST_BROWSER $current_test
    fi
    if [[ $TST_SITE_USR ]]; then
      sed-replace-in-FitNesse "APPIAN_USERNAME" $TST_SITE_USR $current_test
    fi
    if [[ $TST_SITE_URL ]]; then
      sed-replace-in-FitNesse "APPIAN_URL" $TST_SITE_URL $current_test
    fi
    if [[ $TST_SITE_VERSION ]]; then
      sed-replace-in-FitNesse "APPIAN_VERSION" $TST_SITE_VERSION $current_test
    fi
    if [[ $TST_SITE_LOCALE ]]; then
      sed-replace-in-FitNesse "APPIAN_LOCALE" $TST_SITE_LOCALE $current_test
    fi

    echo -e "\\n\\n${GREEN}This is what your FitNesse ${in_echoes} test configuration looks like now${RESET}\\n"
    # TODO: Maybe offer a chance to make edits to this file after viewing
    cat $current_test
  done
}

sed-populate-field() {
  sed -i '' "s|$1=.*|$1=$2|" $3
  # If the field is commented
  sed -i '' "s|#$1=.*|$1=$2|" $3
}

sed-replace() {
    sed -i '' "s#$1#$2#" $3
}

sed-replace-in-FitNesse() {
case "$1" in
        "BROWSER")
            sed-replace "|setup with           |.*" "|setup with           |$2|browser|" $3
            ;;
        "APPIAN_URL")
            sed-replace "|set appian url to    |.*" "|set appian url to    |$2|" $3
            ;;

        "APPIAN_VERSION")
            sed-replace "|set appian version to|.*" "|set appian version to|$2|" $3
            ;;

        "APPIAN_LOCALE")
            sed-replace "|set appian locale to |.*" "|set appian locale to |$2|" $3
            ;;

        "APPIAN_USERNAME")
            sed-replace "|login with username  |.*" "|login with username  |$2|" $3
            ;;
        *)
            echo $"INVALID USAGE"
            exit 1
esac
}

goodbye_message() {
  printf "\\e[38;5;196m"; base64_print ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLgogICAgICAgICAgICAgIC4gLiAgICAgICAgICAgICAgICAgICAgIC06LSAgICAgICAgICAgICAuICAuICAuCiAgICAgICAgICAgIC4nLjosJy4gICAgICAgIC4gIC4gIC4gICAgICcgLiAgICAgICAgICAgLiBcIHwgLyAuCiAgICAgICAgICAgIC4nLjsuYC4gICAgICAgLl8uICEgLl8uICAgICAgIFwgICAgICAgICAgLl9fXDovX18uCiAgICAgICAgICAgICBgLDouJyAgICAgICAgIC5fXCEvXy4gICAgICAgICAgICAgICAgICAgICAuJztgLiAgICAgIC4gJyAuCiAgICAgICAgICAgICAsJyAgICAgICAgICAgICAuICEgLiAgICAgICAgLC4sICAgICAgLi49PT09PT0uLiAgICAgICAuOi4KICAgICAgICAgICAgLCAgICAgICAgICAgICAgICAgLiAgICAgICAgIC5fIV8uICAgICB8fDo6OiA6IHwgLiAgICAgICAgJywKICAgICAuPT09PS4sICAgICAgICAgICAgICAgICAgLiAgICAgICAgICAgOyAgLn4uPT09OiA6IDogOnwgICAuLj09PS4KICAgICB8Ljo6J3x8ICAgICAgLj09PT09LiwgICAgLi49PT09PT09Ln4sICAgfCJ8OiA6fDo6Ojo6OnwgICB8fDo6Onw9PT09PXwKICBfX198IDo6OnwhX18uLCAgfDo6Ojo6fCFfLCAgIHw6IDo6IDo6fCJ8bF9sfCJ8OjogfDo7Ozo6OnxfX18hfCA6Onw6IDogOnwKIHw6IDp8Ojo6IHw6OiB8IV9ffDsgOjogfDogfD09PTo6OiA6OiA6fCJ8fF98fCJ8IDogfDogOjogOnw6IDogfDo6IHw6Ojo6OnwKIHw6Ojp8IF86Onw6IDp8Ojo6fDo9PT06fDo6fDo6Onw6PT09Rj06fCIhL3xcISJ8OjpGfDo9PT09Onw6Ol86fDogOnw6Ol9fOnwKICFfW10hW19dXyFfW10hW11fIV9bX19dIVtdIVtfXSFbX11bSV9dIS8vXzpfXFwhW11JIVtfXVtfXSFfW19dIVtdXyFfW19fXSEKIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIi0tLScnJydgYGAtLS0iLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIF8gXyBfIF8gXyBfIF8gXyBfIF8gXyBfIF8gXyBfIF8gXyBfIHw9IF8gXzpfIF8gPXwgXyBfIF8gXyBfIF8gXyBfIF8gXyBfIF8KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHw9ICAgIDogICAgPXwgICAgICAgICAgICAgICAgU3VjY2VzcyEKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX0xfX19fX19fX19fX0pfX19fX19fX19fX19fX19fX19fX19fX18KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0=
  printf "\\n\\n${GREEN}"; base64_print ICAgIFlvdSBoYXZlIHN1Y2Nlc3NmdWxseSBzZXQgdXAgYWxsIHlvdXIgY29uZmlndXJhdGlvbiBmaWxlcyEKICAgICAgICAgICBZb3VyIHBpcGVsaW5lIGlzIHJlYWR5IHRvIGJlIGtpY2tlZCBvZmYhIAo=
  printf "${RESET}"
}

# Starting point of the script. Redirect to main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
