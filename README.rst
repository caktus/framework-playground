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
    /check?q=word ==> {"valid": true}

    # Invalid word request/response
    /check?q=154o98asdfan ==> {"valid": false}

If the ``q`` parameter is missing the service should return a 400 response.


Acceptance Tests
--------------------------------------------------------------------------------

The included ``tests.py`` runs through a series of acceptance tests for the service.
To run them you must have Python 2.7+ installed and ``python-requests``.::

    pip install requests==1.2.0

To run them you simply call::

    python tests.py

This assumes that the server is running on http://localhost:8000. To change this
host/port you can set the ``TEST_URL`` environment variable.::

    export TEST_URL='http://localhost:8888' && python tests.py
