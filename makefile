APP_NAME_PREFIX=blockchain-python-tutorial
APP_DIR=/src
PWD=$(shell pwd)
DOCKER_IMAGE=python:3.6-slim

BOLD_YELLOW=$(shell printf '\033[0;1;33m')
COLOR_OFF=$(shell printf '\033[0;1;0m')

remove-container:
ifneq ($(shell docker ps -a --filter "name=${container_name}" -aq 2> /dev/null | wc -l | bc), 0)
	@echo "${BOLD_YELLOW}removing container ${container_name} ${COLOR_OFF}"
	@docker ps -a --filter "name=${container_name}" -aq | xargs docker rm -f
endif

remove-all:
	@make remove-container container_name="${APP_NAME_PREFIX}"

docker-command:
	@make remove-container container_name="${APP_NAME_PREFIX}-${app_name}-${id}"
	@echo "${BOLD_YELLOW}starting container ${APP_NAME_PREFIX}-${app_name}-${id}${COLOR_OFF}"
	@# vtrTODO use Dockerfile
	@docker run -it -d \
		-v ${PWD}:${APP_DIR} \
		-w ${APP_DIR} \
		-p ${port}:${port} \
		--name ${APP_NAME_PREFIX}-${app_name}-${id} \
		${DOCKER_IMAGE} \
		bash -c "\
			pip3 install -r requirements.txt && \
			${COMMAND}"

run-api:
	@make docker-command app_name="api" id="${port}" COMMAND="\
		python3 blockchain/blockchain.py \
		-p ${port}"

run-client:
	@make docker-command app_name="client" id="${port}" COMMAND="\
		python3 blockchain_client/blockchain_client.py \
		-p ${port}"
