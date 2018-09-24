build_app() {
  docker build -t tf-demo-app:latest -f app/Dockerfile app
}

deploy_app() {
  terraform apply -auto-approve

  # wait for the app to start
  for i in {1..10}; do 
    curl -fIsS localhost:3000 >/dev/null 2>&1 && break
    sleep 1
  done
  curl -fIsS localhost:3000/posts
}  
