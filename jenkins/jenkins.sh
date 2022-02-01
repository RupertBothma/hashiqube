#!/bin/bash
sudo docker stop jenkins
sudo docker rm jenkins
yes | sudo docker system prune -a
yes | sudo docker system prune --volumes
sudo docker run -d -p 8088:8088 -e JENKINS_OPTS="--httpPort=8088" --restart always --name jenkins -v /var/jenkins_home:/var/jenkins_home jenkins/jenkins:lts
sleep 20
echo -e '\e[38;5;198m'"++++ Using the root Vault token, add a Secret in Vault which Jenkins will retrieve"
echo -e '\e[38;5;198m'"++++ vault secrets enable -path=kv1 kv1"
vault secrets enable -path=secret/testing -version=1 kv
echo -e '\e[38;5;198m'"++++ vault secrets enable -path=kv2 kv2"
vault secrets enable -path=kv2 -version=2 kv
echo -e '\e[38;5;198m'"++++ lets add some secrets in kv2/secret using kv put"
vault kv put kv2/secret/another_test another_test="another_test_VALUE"
echo -e '\e[38;5;198m'"++++ lets list the secrets in kv2/secret using kv get"
vault kv get kv2/secret
echo -e '\e[38;5;198m'"++++ lets add some secrets in kv1/secret using kv put"
vault kv put kv1/secret/testing/ value_one="ONE" value_two="TWO"
echo -e '\e[38;5;198m'"++++ lets list the secrets in kv1/secret/testing using kv get"
vault kv get kv1/secret/testing
echo -e '\e[38;5;198m'"++++ To use Jenkins please open in your browser"
echo -e '\e[38;5;198m'"++++ http://localhost:8088"
echo -e '\e[38;5;198m'"++++ Login with jenkins:jenkins"
