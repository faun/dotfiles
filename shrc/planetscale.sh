#!/usr/bin/env bash

planetscale_branch() {
  current_branch | sed 's/\//-/g' | sed 's/\(.\{63\}\).*/\1/' | sed 's/-$//'
}

planetscale_organization() {
  echo "${PLANETSCALE_ORGANIZATION:?}"
}

planetscale_database() {
  echo "${PLANETSCALE_DATABASE:?}"
}

planetscale_source_branch() {
  echo "${PLANETSCALE_SOURCE_BRANCH:?}"
}

planetscale_branch_create_migrate_and_deploy_request() {
  planetscale_branch_create_and_migrate && planetscale_branch_deploy_request && planetscale_branch_deploy_request_open
}

planetscale_branch_migrate() {
  rails psdb:migrate
}

planetscale_branch_rollback() {
  rails psdb:rollback
}

planetscale_branch_create_and_migrate() {
  planetscale_branch_create_sync && planetscale_branch_migrate && planetscale_branch_open
}

planetscale_branch_create() {
  pscale branch switch --org "$(planetscale_organization)" --database "$(planetscale_database)" --create "$(planetscale_branch)" --parent-branch "$(planetscale_source_branch)"
}

planetscale_branch_create_sync() {
  planetscale_branch_create && planetscale_branch_wait_for_ready
}

planetscale_branch_wait_for_ready() {
  echo -e "\n\nWaiting for branch $(planetscale_branch) to be ready"
  while [[ "$(pscale branch --org "$(planetscale_organization)" show "$(planetscale_database)" "$(planetscale_branch)" --format json | jq '.ready')" != "true" ]]; do
    echo -n "."
    sleep 1
  done
  echo
  echo "Branch is ready"
}

planetscale_branch_status() {
  pscale branch show --org "$(planetscale_organization)" "$(planetscale_database)" "$(planetscale_branch)" --format json | jq
}

planetscale_branch_switch() {
  pscale branch switch --org "$(planetscale_organization)" --database "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_list() {
  pscale branch list --org $(planetscale_organization) "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_show() {
  pscale branch show --org $(planetscale_organization) "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_connect() {
  pscale connect --org $(planetscale_organization) "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_shell() {
  pscale shell --org $(planetscale_organization) "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_open() {
  pscale branch show --org "$(planetscale_organization)" "$(planetscale_database)" "$(planetscale_branch)" --format json | jq -r .html_url | open
}

planetscale_branch_delete() {
  pscale branch delete --org "$(planetscale_organization)" "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_deploy_request() {
  pscale deploy-request create --org "$(planetscale_organization)" "$(planetscale_database)" "$(planetscale_branch)"
}

planetscale_branch_deploy_request_status() {
  pscale deploy-request show --org "$(planetscale_organization)" "$(planetscale_database)" "$(planetscale_branch_deploy_request_number)" --format json | jq
}

planetscale_branch_deploy_request_wait_for_ready() {
  echo -n "Waiting for deploy request $(planetscale_branch_deploy_request_number) to be ready"
  while [[ "$(planetscale_branch_deploy_request_status | jq '.ready')" != "true" ]]; do
    echo -n "."
    sleep 1
  done
  echo
  echo "Deploy request is ready"
}

planetscale_branch_deploy_request_delete() {
  pscale deploy-request delete --org "$(planetscale_organization)" "$(planetscale_database)" "$(planetscale_branch_deploy_request_number)"
}

planetscale_branch_deploy_request_number() {
  pscale deploy-request list --org "$(planetscale_organization)" "$(planetscale_database)" --format json | jq -r ".[] | select(.branch == \"$(planetscale_branch)\") | select(.state == \"open\") .number"
}

planetscale_branch_deploy_request_open() {
  echo "https://app.planetscale.com/$(planetscale_organization)/$(planetscale_database)/deploy-requests/$(planetscale_branch_deploy_request_number)" | open
}
