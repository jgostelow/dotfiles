NAME ?= dev

build:
	docker build -t ${NAME} .


run:
	docker run --name ${NAME} -ti ${NAME} -v dotfiles:~/dotfiles


clean:
	docker rm $(docker ps -aq)
	docker image prune

