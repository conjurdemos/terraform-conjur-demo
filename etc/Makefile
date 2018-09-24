version = v0.2.0
os := $(shell go env GOHOSTOS)
arch := $(shell go env GOHOSTARCH)

terraform.d/plugins/${os}_${arch}/terraform-provider-conjur: 
	mkdir -p $(@D)
	curl -sSL https://github.com/cyberark/terraform-provider-conjur/releases/download/${version}/terraform-provider-conjur-${os}-${arch}.tar.gz | tar -C $(@D) -x -z -f -

