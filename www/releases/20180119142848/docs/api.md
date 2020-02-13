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
406        | Not Acceptable -- You requested a format that isn't json.
410        | Gone -- The kitten requested has been removed from our servers.
418        | I'm a teapot.
429        | Too Many Requests -- You're requesting too many kittens! Slow down!.
500        | Internal Server Error -- We had a problem with our server. Try again later.
503        | Service Unavailable -- We're temporarially offline for maintanance. Please try again later.

# Authentication

<pre class="highlight"><code><span class="na">Token</span><span class="p">:</span> <span class="s">&lt;base64 id:token&gt;</span></code></pre>

To authenticate with the API, supply a `Token` header with the Base64 encoding
of the UserID, SubUserID, and API key separated by colons (`user_id:sub_user_id:api_key`)
