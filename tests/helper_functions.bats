#!/usr/bin/env bats

setup() {
  load ../bin/_functions
}

@test "check valid input" {
  valid_data="$(cat <<EOF
some secret was created
AND MORE DATA
EOF
)"

  run scrub_secret_data "${valid_data}"

  echo -e "Input:\n${valid_data}\n"
  echo -e "Output:\n${output}"

  [ "$status" -eq 0 ]
  [ "${output}" = "${valid_data}" ]
  [ "${lines[0]}" != "" ]
}

@test "check scrubable input" {
  valid_data=$(cat <<EOF
Some data
{"metadata":{"annotations":{"kubectl.kubernetes.io/last-applied-configuration":"{\"apiVersion\":\"v1\",\"kind\":\"Secret\",\"metadata\":{\"annotations\":{},\"name\":\"baddata-env\",\"namespace\":\"default\"},\"stringData\":{}}
some more data
{"apiVersion": "v1", "kind": "Secret", "data": {"data1": "value1"}}
}},\"stringData\": {}
}},"stringData": {}
final line of doc
EOF
)

  run scrub_secret_data "${valid_data}"

  echo -e "Input:\n${valid_data}\n"
  echo -e "Output:\n${output}"

  [ "$status" -eq 0 ]
  [ "${lines[1]}" = "REDACTED OBJECT" ]
  [ "${lines[3]}" = "REDACTED OBJECT" ]
  [ "${lines[4]}" = "REDACTED OBJECT" ]
  [ "${lines[5]}" = "REDACTED OBJECT" ]
  [ "${lines[6]}" = "final line of doc" ]
}

@test "check fail on more than one argument" {
  run scrub_secret_data "ok" "badarg"

  [ "$status" -eq 1 ]
}
