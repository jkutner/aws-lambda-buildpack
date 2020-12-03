# AWS Lambda Buildpack

A Cloud Native Buildpack for AWS Lambda

## Usage

Package the buildpack:

```
$ pack package-buildpack -c package.toml jkutner/lambda
```

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

Run the buildpack:

```sh-session
$ pack build --buildpack jkutner/lambda my-lambda
```

Run it locally:

```sh-session
$ docker run -p 9000:8080 my-lambda
```

And test it:

```sh-session
$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
"Hello World!"
```

Then create a lambda and deploy following the [AWS Lambda guide to Container Image Support](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/).

## License

MIT