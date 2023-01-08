#from crypt import methods
from flask import Flask, redirect, url_for, request, jsonify
import werkzeug
import cv2
import hh
app = Flask(__name__)


@app.route('/success', methods = ['POST', 'GET'])
def success():
	return 'welcome fahad'

@app.route('/upload', methods = ['POST', 'GET'])
def upload():
    
    print(request.files)
    
    if(request.method == 'POST'):
        imagefile = request.files['image']
        #print(imagefile)
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        imagefile.save("./uploadedImages/" + filename)
        image = cv2.imread("./uploadedImages/" + filename)
        #cv2.imshow("image", image)
        #cv2.waitKey(0)
        sentence = hh.predict("./uploadedImages/" + filename)
        return jsonify({
            'message':sentence
            })
    else:
        return 'browser'

if __name__ == '__main__':
	app.run(debug=True, port=5000)
