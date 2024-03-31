tmux:
	pushd tmux
	bash setup.sh
	popd

fish:
	pushd
	bash setup.sh
	popd

all:
	tmux
	fish