FROM hashicorp/terraform:1.9.0

RUN apk add --no-cache aws-cli zsh zsh-vcs ncurses
RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

ADD ./.zshrc /root/.zshrc
RUN apk add zsh-syntax-highlighting
RUN echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /root/.zshrc


ENTRYPOINt ["/bin/zsh"]


