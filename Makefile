# Copyright (c) 2021 Terminus, Inc.
#
# This program is free software: you can use, redistribute, and/or modify
# it under the terms of the GNU Affero General Public License, version 3
# or later ("AGPL"), as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

GO_PROJECT_ROOT := github.com/erda-project/erda

REGISTRY := registry.cn-hangzhou.aliyuncs.com/dice
BUILD_DIR := ./build
TARGETS_DIR := dice-operator
IMAGE_PREFIX ?= $(strip )
IMAGE_SUFFIX ?= $(strip )

IMAGE_TAG ?= $(shell git describe --abbrev=0 --tags --always)-$(shell date -u +%Y%m%d)
DOCKER_LABELS ?= git-describe="$(shell git describe --abbrev=0 --tags --always)-$(shell date -u +%Y%m%d)"

GO_OPTIONS ?= -mod=vendor -count=1
SHELLOPTS := errexit

container:
	@for target in $(TARGETS_DIR); do                                                  \
	  image=$(IMAGE_PREFIX)$${target}$(IMAGE_SUFFIX);                                  \
	  docker build -t $(REGISTRY)/$${image}:$(IMAGE_TAG)                               \
	    --build-arg GO_PROJECT_ROOT=$(GO_PROJECT_ROOT)                                 \
	    --label $(DOCKER_LABELS)                                                       \
	    -f $(BUILD_DIR)/$${target}/Dockerfile .;                                       \
	done

push: container
	@for target in $(TARGETS_DIR); do                                                  \
	  image=$(IMAGE_PREFIX)$${target}$(IMAGE_SUFFIX);                                  \
	  docker push $(REGISTRY)/$${image}:$(IMAGE_TAG);                                  \
	done