# AWS Lambda Buildpack

A Cloud Native Buildpack for AWS Lambda

## Usage

Create a function by adding the following code to an `app.js` file:

```js
"use strict";

exports.handler = async (event, context) => {
    return '{"message": "Hello World!"}';
}
```

Initialize the app:

```sh-session
$ npm init
```

Install the [Pack CLI](https://buildpacks.io/docs/tools/pack/) and run the buildpack:

```sh-session
$ pack trust-builder jkutner/aws-lambda-builder:18
$ pack build --builder jkutner/aws-lambda-builder:18 my-lambda
```

Run your lambda image locally:

```sh-session
$ docker run -p 9000:8080 my-lambda
```

And test it:

```sh-session
$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
"Hello World!"
```

Then create a lambda and deploy following the [AWS Lambda guide to Container Image Support](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/). In short:

```
$ aws ecr create-repository --repository-name my-lambda --image-scanning-configuration scanOnPush=true
$ docker tag random-letter:latest <image-repo>/my-lambda:latest
$ aws ecr get-login-password | docker login --username AWS --password-stdin <image-repo>
$ docker push <image-repo>/my-lambda:latest
```

Then create the Lambda and a Trigger via the AWS Console.

## Customizing

By default, the buildpack will try to execute a handler named `app.handler` (matching the `exports.handler` in `app.js`). You can customize this by setting the `HANDLER` environment variable (ex. `docker run -e HANDLER="foo.bar" ...`). Or you can add a `Procfile` to repo to completely override the launch process.

Follow the [Heroku Node.js Support guide](https://devcenter.heroku.com/articles/nodejs-support) for information on customizing the Node.js and NPM environments.

## Packaging the Buildpack

If you want to work with the buildpack independent of the `jkutner/aws-lambda-builder` image, run `make create-buildpack` to package a `jkutner/aws-lambda-cnb` image containing the buildpack.

## Using the Heroku Stack

By default, this repo is setup to use the `jkutner/aws-lambda:18-tiny` image, which is _NOT_ production ready.

If you would prefer to ship a more secure and full-featured run-image (but also larger), you can use the [Heroku stack image](https://devcenter.heroku.com/articles/stack) by using the `heroku/buildpacks:18` builder image:

```
$ pack build --builder heroku/buildpacks:18 --buildpack jkutner/aws-lambda my-lambda
```

## License

MIT