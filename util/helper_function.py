import datetime,subprocess,sys,os,json
import numpy as np
#import networkx as nx
import matplotlib.pyplot as plt
from scipy.stats import norm
#################################################################
def RemoteExec(node,command):
    CMD="sshpass -p \"raspberry\" ssh -o StrictHostKeyChecking=no pi@%s \"%s\""%(node,command)
    print(CMD)
    proc = subprocess.Popen(CMD,shell=True, stdout=subprocess.PIPE)
    (out, err) = proc.communicate()
    if err:
        print("SSHPASS:Err-%s"%(err))
    return(out)
#################################################################
def execRes(command):
    proc = subprocess.Popen(command,shell=True, stdout=subprocess.PIPE)
    (out, err) = proc.communicate()
    if err:
        print("EXECUTE:Err-%s"%(err))
    return(out)
#################################################################
# Function to read from a file
def getDictFrom(filename):
    file_handler=open(filename,"r")
    variable=json.load(file_handler)
    file_handler.close()
    return(variable)
#################################################################
# Function to write to a file
def putDictTo(filename,variable):
    file_handler=open(filename,"w")
    json.dump(variable, file_handler)
    file_handler.flush()
    file_handler.close()
    return
#################################################################
#fog node's available resource set calculation function.
def RFi(i,q):
    return total_available_quantity_of_resource[i][q];
#################################################################
#micro-service's needed resource set calculation function.
def GammaPxy(x,y,q):
    return total_quantity_of_resource_needed[x][y][q];
#################################################################
#Executing micro-service vector calculation function
def exe_ms_vector(A_temp,i,t):
    Omega=np.zeros((no_of_services,max_no_of_micro_services))
    for k in range(0,no_of_services):
        for j in range(0,max_no_of_micro_services):
            if (A_temp[k][j][i][t]==1):
                Omega[k][j]=A_temp[k][j][i][t]  
    return Omega;
#################################################################
#Amount of resource type occupied calculation function
def amount_of_resource_type_occupied(A_temp,i,q,gamma,t):
    sum=0
    for k in range(0,no_of_services):
        for j in range(0,max_no_of_micro_services):
            sum+=(exe_ms_vector(A_temp,i,t)[k][j])*GammaPxy(k,j,q)            
    return sum;
#################################################################
def rowMajorTo2D(allocation_vector,**kwargs):
    A=np.array(allocation_vector).reshape(kwargs["no_of_services"],kwargs["max_no_of_micro_services"],kwargs["no_of_fog_nodes"],kwargs["no_of_time_slots"])
    return A

#################################################################
def performDataTransfer():
    ''' After deciding allocation_vector'''
    ''' inform super controller to apply configuration change, which informs local controller
    url = 'http://127.0.0.1:8080/stats/start_switch_change'
    started_migration = json.loads(requests.get(url).text)
    if started_migration["status"]:
        print("Switch migration started.")
        result_file.write("Switch migration started.\n")
    else:
        print("Switch migration could not be started.")
        result_file.write("Switch migration could not be started.\n")
        return

    receive message that change is applied It is not possible for now. so we would just wait for 
    60 seconds before proceeding ahead. Also topology discovery is to be done so better wait for
    some time
    print("Sleeping for 60 seconds to let switch migration and topology discovery happen.")
    result_file.write("Sleeping for 60 seconds to let switch migration and topology discovery happen.\n")
    result_file.flush()
    time.sleep(60)
    print("Got up!! switch update should be done by now.")
    result_file.write("Got up!! switch update should be done by now.\n")

    run test for 2 minutes
    assuming there are 6 switches, if more update line number 76 in RunTest.py. For deleting flow
    entries'''
    os.system("ps -ef | grep mininet:h > traffic_generator/host_pid.list")
    time.sleep(5)
    startScriptName = BOpath+"/traffic_generator/StartTest.sh"
    executeScriptName = BOpath+"/traffic_generator/ExecuteTest.sh"
    RunTest.create_scripts(startScriptName, executeScriptName)
    print("Test scripts generated.")
    result_file.write("Test scripts generated.\n")

    print("Cleaning up.")
    result_file.write("Cleaning up.\n")
    cleanup.cleanup()
    time.sleep(5)

    # run these scripts
    print("starting servers.")
    result_file.write("starting servers.\n")
    os.system("sudo bash "+startScriptName)
    time.sleep(5)
    print("starting traffic execution")
    result_file.write("starting traffic execution.\n")
    os.system("sudo bash "+executeScriptName)
    time.sleep(5)

    # ask super controller about number of updates
    # pass that info to bayesian function
    # t = sum(allocation_vector)
    url = 'http://127.0.0.1:8080/stats/get_update_counter'
    update_count = json.loads(requests.get(url).text)
    t = update_count["update_counter"]
    print("Number of Updates: ",t)
    result_file.write("Number of Updates: " + str(t) +"\n")
    time.sleep(5)

    inter_domain_flows = countInterDomainFlows.count_inter_domain_flow()
    print("Actual number of flows should have been %s", inter_domain_flows)
    result_file.write("Actual number of flows should have been " + str(inter_domain_flows) +"\n")

    probed_points_y.append(t)
    result_file.flush()
    return t

#################################################################
# Function to check if cumulative occupied resources by micro-services executing on a single node has not surpassed the total available resource at that node
def IsFeasible(vec,**kwargs):
    arr=np.zeros((kwargs["no_of_services"],kwargs["max_no_of_micro_services"],kwargs["no_of_fog_nodes"],kwargs["no_of_time_slots"]))
    arr=rowMajorTo2D(vec,**kwargs)
    # Check allocation matrix for the constraint that 1 microservice can be in exactly 1 fog node
    ### Constraint 1
    cnt=[0 for i in range(0,kwargs["no_of_fog_nodes"])]

    for i in range(0,kwargs["max_no_of_micro_services"]):
        for j in range(0,kwargs["no_of_fog_nodes"]):
            if(vec[(i*kwargs["no_of_fog_nodes"])+j]==1):
                cnt[i]+=1

    if(len([c for c in cnt if c!=1])>0):
        print("Not a valid allocation matrix: At least one microservice is allocated to more than one fog node.")
        return False
    ### Constraint 2
    var_flag=True # flag is 1 means, fog node has sufficient resource to execute the micro-service
    #Checking if cumulative occupied resources by micro-services executing on a single node has not surpassed the total available resource at       that node
    for i in range(0,kwargs["no_of_fog_nodes"]):
        for j in range(0,kwargs["no_of_resource_type"]):
            for k in range(0,kwargs["no_of_time_slots"]):
                ppp1=amount_of_resource_type_occupied(arr,i,j,kwargs["total_quantity_of_resource_needed"],k)
                #print "amount of resource type occupied is:",ppp1
                ppp2=RFi(i,j)
                #print "Fog node's available resource is",ppp2
                if (ppp1>ppp2):
                    var_flag=False

    #print "var_flag is:",var_flag
    return var_flag
#################################################################
def map_fog_ip(x):
    if(x==0):
        return '10.14.83.90';
    elif(x==1):
        return '10.14.84.105';
    elif(x==2):
        return '10.14.84.100';
    elif(x==3):
        return '10.14.83.99';
    else:
        return '10.14.83.92';
#################################################################
'''

no_of_vertices=7
no_of_sensors=1
no_of_actuators=1
no_of_fog_nodes=no_of_vertices-no_of_sensors-no_of_actuators
no_of_services=1
max_no_of_micro_services=5
no_of_resource_type=1
no_of_time_slots=1
total_available_quantity_of_resource=np.zeros((no_of_fog_nodes,no_of_resource_type))
total_quantity_of_resource_needed=np.zeros((no_of_services,max_no_of_micro_services,no_of_resource_type))

Psi=np.zeros((no_of_services,max_no_of_micro_services)) #micro service set. 
#micro service set for service 1. Service 1 has 5 micro-services.
for tm_w in range(0,no_of_services):
    strtm1="msforservice"
    strtm2=str(tm_w+1)
    strtm3=".txt"
    strtm4=strtm1+strtm2+strtm3    
    Psi[tm_w]=getDictFrom(strtm4)

total_available_quantity_of_resource=getDictFrom('consolidated_status_fog_ram.txt')  # total available quantity of resource of different type in fog nodes

d_res=9 # 8.8 MB. 
for i in range(0,no_of_services):
    for j in range(0,max_no_of_micro_services):
        if Psi[i][j]!=0:
            for k in range(0,no_of_resource_type):
                total_quantity_of_resource_needed[i][j][k]=d_res  # total quantity of resources needed by different micro-services
'''