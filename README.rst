Web Framework Playgroud
================================================================================

This project includes experiments of writing services in various web frameworks.

To contribute an example you should create a subdirectory in the appropriate
language for your app.


Service Description
--------------------------------------------------------------------------------

Each example service should expose a single url for spell checking a word.::

    /check?q=word

The single parameter ``q`` is required. The service should check the word verse
an English dictionary and return a JSON response indicating whether or not the
word is a valid English word::

    # Valid word request/response
    /check?q=word ==> {'valid': true}

    # Invalid word request/response
    /check?q=154o98asdfan ==> {'valid': false}

If missing the service should return a 400 response.