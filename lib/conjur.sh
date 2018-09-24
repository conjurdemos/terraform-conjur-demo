export TF_VAR_demo_net=tf-demo

appliance_url=http://localhost:8080
account=cucumber
conjurrc=$PWD/conjurrc

init() {
  # cli init --force -f ${conjurrc} -u ${appliance_url} -a ${account}
  :
}

conjur_curl() {
  curl ${CONJUR_AUTH_HEADER+-H} "$CONJUR_AUTH_HEADER" -fsS "$@"
}

login_to_conjur() {
  # export CONJURRC=${conjurrc} CONJUR_AUTHN_LOGIN=admin
  export CONJUR_APPLIANCE_URL=$appliance_url CONJUR_ACCOUNT=$account CONJUR_AUTHN_LOGIN=admin

  CONJUR_AUTHN_API_KEY=$(docker-compose exec -T conjur conjurctl role retrieve-key ${account}:user:admin | tr -d '\r')
  export CONJUR_AUTHN_API_KEY

  export CONJUR_AUTH_HEADER="$(conjur_cli authn authenticate -H)"
}

conjur_cli() {
  docker-compose run -T -e CONJUR_APPLIANCE_URL=http://conjur --rm -v $PWD:$PWD -w $PWD cli "$@"
}

# start_password_rotation ensures that management of the password value has been handed off to
# Conjur
start_password_rotation() {
  conjur_cli policy load root policy/app-rotate.yml
  sleep 1 # give the password a chance to rotate
}

rotate_password() {
  conjur_curl -X POST "${appliance_url}/secrets/${account}/variable/tf-demo/app-password?expirations"
  sleep 1
}


