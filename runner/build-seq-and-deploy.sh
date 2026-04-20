docker build -t my-runner-image . &&

for i in $(seq 1 1); do
  docker run -d --privileged \
    --name runner-$i \
    --cpus="2" \
    --memory="4g" \
    -e RUNNER_NAME=runner-$i \
    -e GITHUB_PAT="" \
    -e OWNER="Karen0student" \
    -e REPO="CI-CD_test" \
    my-runner-image
done