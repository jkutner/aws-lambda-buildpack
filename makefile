.EXPORT_ALL_VARIABLES:

SHELL=/bin/bash -o pipefail

create-buildpack:
	@pack package-buildpack -c package.toml jkutner/lambda-cnb:latest

create: create-buildpack
	@docker build -t jkutner/lambda:18-build -f builder/Dockerfile.build builder/
	@docker build -t jkutner/lambda:18-tiny -f builder/Dockerfile.run builder/
	@pack create-builder jkutner/lambda-builder:18 -c builder/builder.toml --no-pull

publish:
	@docker push jkutner/lambda-cnb:latest
	@docker push jkutner/lambda:18-build
	@docker push jkutner/lambda:18-tiny
	@docker push jkutner/lambda-builder:18