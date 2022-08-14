from flask import Flask, request
from json_to_xml import transform_json_to_xml


app = Flask(__name__)


@app.route('/transform_json_to_xml', methods=['POST'])
def take_json_get_xml():
    return transform_json_to_xml(request.data)


if __name__ == '__main__':
    app.run(host='localhost', port=7777)
