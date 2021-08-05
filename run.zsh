# zsh prezto のインストール
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

# vim の設定
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
mkdir ~/.vimbackup

# シンボリックリンクを貼る
rm ${HOME}/.zpreztorc ${HOME}/.zshrc
for i in .gitconfig .tmux.conf .vimrc .zpreztorc .zshrc; do
  ln -s ${PWD}/${i} ${HOME}/${i}
done
