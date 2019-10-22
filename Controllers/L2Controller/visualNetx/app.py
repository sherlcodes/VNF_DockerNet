import os
import time
from flask import Flask, send_file, json, request, redirect, url_for, send_from_directory
from werkzeug.utils import secure_filename

import networkx as nx
from networkx.readwrite import json_graph

UPLOAD_FOLDER = 'upload/'
GENERATE_FOLDER = 'generate/'
ALLOWED_EXTENSIONS = set(['json','adjlist', 'edgelist','gexf','gml','gpickle','graphml','yaml','net'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['GENERATE_FOLDER'] = GENERATE_FOLDER
app.config['GENERATED_GRAPH'] = None

@app.route("/")
def index():
    return send_file("templates/index.html")

@app.route("/generateGraph", methods=['POST'])
def generate_graph():
    try:
        action = request.json['userAction']
        G = eval('nx.'+action)
        app.config['GENERATED_GRAPH'] = G
        data = json_graph.node_link_data(G)
        return json.dumps(data)
    except:
        return "error"

@app.route('/uploadGraph', methods=['POST'])
def upload_graph():
    if 'file' not in request.files:
        flash('No file part')
        return "error"
    file = request.files['file']

    if file.filename == '':
        flash('No selected file')
        return "error"
    if file:
        filename = secure_filename(file.filename)
        extension = filename.rsplit('.', 1)[1]
        if extension in ALLOWED_EXTENSIONS:
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            G = None
            if extension == "net":
                G = nx.read_pajek(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            if extension == "json":
                pass
            else:
                G = eval("nx.read_"+extension+"(os.path.join(app.config['UPLOAD_FOLDER'], filename))")
            if(G==None):
                filename=os.path.join(app.config['UPLOAD_FOLDER'], filename)
                with open(filename) as json_file:  
                    data = json.load(json_file)
                print(filename)
            else:
                data = json_graph.node_link_data(G)
                print(data)
            return json.dumps(data)

@app.route('/exportGraph', methods=['POST'])
def export_graph():
    if app.config['GENERATED_GRAPH']:
        requestFormat = request.json['fmat']
        filename = str(int(time.time()))
        #choose graph generator based on user selection
        if requestFormat == "pajek":
            filename += ".net"
        else:
            filename += '.' + requestFormat
        fPath = os.path.join(app.config['GENERATE_FOLDER'], filename)
        fh=open(fPath,'wb')
        eval("nx.write_"+requestFormat+"(app.config['GENERATED_GRAPH'], fh)")
        fh.close()
        return url_for('generated_file',filename=filename)

    else:
        return "error"


@app.route('/generated/<filename>')
def generated_file(filename):
    return send_from_directory(app.config['GENERATE_FOLDER'],filename, as_attachment=True)



if __name__ == "__main__":
    app.run(host='0.0.0.0',port=9101)
