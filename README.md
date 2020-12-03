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
    return 'Hello World!';
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

## License

MIT