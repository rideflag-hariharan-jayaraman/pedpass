# Introduction

Welcome to the Pedestrian API! You can use our API to grab data from our database and make updates.

This API supports the [JSON API spec](http://jsonapi.org/). Please follow its guidelines to learn about:

- The Document Structure
- Including Relationships
- Pagination
- Sorting
- Error Objects

# Errors

The Pedestrian API uses the following error codes:

Error Code | Meaning
---------- | -------
400        | Bad Request -- Your request sucks.
401        | Unauthorized -- Your API token is wrong.
403        | Forbidden -- The kitten requested is not available for you.
404        | Not Found -- The specified kitten could not be found.
405        | Method Not Allowed -- You tried to access a kitten with an invalid method.
406        | Not Acceptable -- You requested a format that isn't JSON.
410        | Gone -- The kitten requested has been removed from our servers.
418        | I'm a teapot.
429        | Too Many Requests -- You're requesting too many kittens! Slow down!.
500        | Internal Server Error -- We had a problem with our server. Try again later.
503        | Service Unavailable -- We're temporarily offline for maintenance. Please try again later.

# Authentication
JWT Auth is used for authentication, which verifies a user by passing a token in the
`Authorization` header. Please refer to Session end point to retrieve the token.
For more information regarding JWT, please refer to:

<https://jwt.io/introduction/>

# Localization
Currently, the following languages are supported english (en), french (fr), and
spanish (es). The language can be passed through the `Accept-Language` header.
The expected value will be the shorthand code for the language, i.e en, es, fr.

<https://jwt.io/introduction/>
