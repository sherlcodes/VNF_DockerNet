import subprocess
#################################################################
def execute(CMD):
    CMD=CMD.split(" ")
    out = subprocess.Popen(CMD,
        stdout=subprocess.PIPE, 
        stderr=subprocess.STDOUT)
    result,stderr = out.communicate()
    return({'cmd':' '.join(CMD),'output': result,'stderr':stderr})
#################################################################
def mnExec(netDict,nodeName,cmd="echo hello"):
    pid=netDict[nodeName]["pid"]
    ret=execRes("mnexec -a %s %s"%(pid,cmd))
    return(ret)
#################################################################
