from __future__ import unicode_literals

import os
import unittest

import requests


SERVER_BASE = os.environ.get('TEST_URL', 'http://localhost:8000')
SERVER_URL = SERVER_BASE + '/check'


class SpellCheckerTests(unittest.TestCase):
    "Acceptance tests for spell checking service examples."

    def _make_request(self, word=None):
        params = None
        if word is not None:
            params = {'q': word}
        return requests.get(SERVER_URL, params=params)

    def test_valid_words(self):
        "Ask the server to check valid words."
        words = ['dog', 'cat', 'cactus', 'razzmatazz', ]
        for word in words:
            response = self._make_request(word=word)
            self.assertEqual(response.status_code, 200)
            result = response.json()
            self.assertTrue(result['valid'], '%s should be a valid word.' % word)

    def test_invalid_words(self):
        "Ask the server to check invalid words."
        words = ['123', '$^%$%','asdflkahdrflauhflkafda', 'google.com', ]
        for word in words:
            response = self._make_request(word=word)
            self.assertEqual(response.status_code, 200)
            result = response.json()
            self.assertFalse(result['valid'], '%s should be an invalid word.' % word)

    def test_missing_parameter(self):
        "Send a request without the 'q' parameter."
        response = self._make_request(word=None)
        self.assertEqual(response.status_code, 400)


if __name__ == '__main__':
    unittest.main()