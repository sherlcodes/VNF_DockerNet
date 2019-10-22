from werkzeug.wrappers import Request, Response
from werkzeug.serving import run_simple
import subprocess
from jsonrpc import JSONRPCResponseManager, dispatcher

controller_ip_port = {"C1" : {"IP" : "127.0.0.1", "Port" : "6633" }, "C2" : {"IP" : "127.0.0.1", "Port" : "6634" }}

@dispatcher.add_method
def setController(**kwargs):
    IP = controller_ip_port[kwargs["controller"]]["IP"]
    Port = controller_ip_port[kwargs["controller"]]["Port"]
    CMD="ovs-vsctl set-controller %s tcp:%s:%s"%(kwargs["switch"], IP, Port)
    print CMD
    proc = subprocess.Popen(CMD,shell=True, stdout=subprocess.PIPE)
    (output, err) = proc.communicate()
    print "Executed the command output: " + str(output) + " Error: " + str(err)
    return  CMD


@Request.application
def application(request):
    # Dispatcher is dictionary {<method_name>: callable}
    dispatcher["echo"] = lambda s: s
    dispatcher["add"] = lambda a, b: a + b
    
    response = JSONRPCResponseManager.handle(
        request.data, dispatcher)
    return Response(response.json, mimetype='application/json')


if __name__ == '__main__':
	run_simple('localhost', 4000, application)