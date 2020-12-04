.EXPORT_ALL_VARIABLES:

SHELL=/bin/bash -o pipefail

create-buildpack:
	@pack package-buildpack -c package.toml jkutner/aws-lambda-cnb:latest

create: create-buildpack
	@docker build -t jkutner/aws-lambda:18-build -f builder/Dockerfile.build builder/
	@docker build -t jkutner/aws-lambda:18-tiny -f builder/Dockerfile.run builder/
	@pack create-builder jkutner/aws-lambda-builder:18 -c builder/builder.toml --pull-policy never

publish:
	@docker push jkutner/aws-lambda-cnb:latest
	@docker push jkutner/aws-lambda:18-build
	@docker push jkutner/aws-lambda:18-tiny
	@docker push jkutner/aws-lambda-builder:18