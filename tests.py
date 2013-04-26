# -*- coding: utf-8 -*-

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
        words = ['dog', 'cat', 'cactus', 'razzmatazz', 'éclair']
        for word in words:
            response = self._make_request(word=word)
            self.assertEqual(response.status_code, 200)
            result = response.json()
            self.assertTrue(result['valid'], '%s should be a valid word.' % word)

    def test_multiple_qs(self):
        "Ask for multiple valeus of q. (No guarantee which one will be answered.)"
        nonwords = ['ninininini', 'alskfj']
        finewords = ['blooming', 'raspberry']
        response = requests.get('%s?q=%s&q=%s' % (SERVER_URL, nonwords[0], nonwords[1]))
        self.assertEqual(response.status_code, 200)
        result = response.json()
        self.assertFalse(
            result['valid'],
            'q parameters of all nonwords (%r) should not be considered valid.' % nonwords)
        response = requests.get("%s?q=%s&q=%s" % (SERVER_URL, finewords[0], finewords[1]))
        self.assertEqual(response.status_code, 200)
        result = response.json()
        self.assertTrue(
            result['valid'],
            'q parameters of all fine words (%r) should be considered valid.' % finewords)

    def test_valid_words_case_sensitivity(self):
        "Ask the server to check valid words."
        words = ['DOG', 'Cat', 'Cactus', 'Razzmatazz', 'Éclair' ]
        for word in words:
            response = self._make_request(word=word)
            self.assertEqual(response.status_code, 200)
            result = response.json()
            self.assertTrue(result['valid'], '%s should be a valid word.' % word)

    def test_invalid_words(self):
        "Ask the server to check invalid words."
        words = ['123', '$^%$%', 'asdflkahdrflauhflkafda', 'google.com', ]
        for word in words:
            response = self._make_request(word=word)
            self.assertEqual(response.status_code, 200)
            result = response.json()
            self.assertFalse(result['valid'], '%s should be an invalid word.' % word)

    def test_missing_parameter(self):
        "Send a request without the 'q' parameter."
        response = self._make_request(word=None)
        self.assertEqual(response.status_code, 400)

    def test_invalid_url(self):
        "Send a request other than /check"
        response = requests.get(SERVER_BASE + "/uncheck")
        self.assertEqual(response.status_code, 404)


if __name__ == '__main__':
    unittest.main()
