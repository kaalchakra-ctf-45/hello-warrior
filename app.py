from flask import Flask, request
from pickle import loads


app = Flask(__name__)


@app.route('/api', methods=['POST'])
def api():
    if request.method == 'GET': return 'GET method not allowed >:(', 405
    # 1. Get the 'obj' query parameter, which should be a pickled object
    try: pickled_obj = request.json.get('obj')
    except: return f'Error in processing body as JSON', 400

    try:
        # 2. Unpickle the obj (this is where the vulnerability is)
        obj = loads(bytes.fromhex(pickled_obj))
        print(f'[*] Unpickled object: {obj} (type: {type(obj)}) from {request.remote_addr}')
        # 3. Do something with the unpickled object (for demonstration, we'll just return its string representation)
        # if not isinstance(obj, str): return 'Not a string >:(', 400
        return f'Good luck in the battle {obj}!', 200

    except Exception as e:
        print(f'[-] Error processing obj from {request.remote_addr}: {e}')
        return f'Error processing obj', 400


if __name__ == '__main__':
    # 0.0.0.0 so that it can be accessed from outside the container
    app.run(host='0.0.0.0', port=5000)


