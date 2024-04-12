FROM amazon/aws-cli:2.15.37

LABEL "com.github.actions.name"="AWS CodeDeploy"
LABEL "com.github.actions.description"="Deploy your code with AWS CodeDeploy to your instance"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL version="0.0.1"
LABEL repository="https://github.com/padm-io/gh-action-codedeploy"
LABEL homepage="https://padm.io/"
LABEL maintainer="Padm™"

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]