.PHONY: all tmux_setup fish_setup

all: tmux_setup fish_setup

tmux_setup:
	@echo "Setting up tmux..."
	@cd ./tmux && bash setup.sh && cd ..

fish_setup:
	@echo "Setting up fish..."
	@cd ./fish && bash setup.sh && cd ..