import json
import re

import enchant
from flask import Flask, request, abort, jsonify


app = Flask(__name__)

english = enchant.Dict("en_US")


@app.route("/check")
def check_spelling():
    word = request.args.get('q', None) or None
    if word is None:
        abort(400)
    valid = re.search(r'[a-zA-Z]+', word)
    return jsonify(valid=valid and english.check(word))


if __name__ == "__main__":
    app.run()