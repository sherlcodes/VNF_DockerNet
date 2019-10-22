#!/usr/bin/python
from bottle import route, run, template
import time, subprocess, json, sys
sys.path.append("../modified_pdb")
#import modified_pdb
#from bottledaemon import daemon_run
"""
PdbRest adds a REST API to Pdb.
"""
IP='localhost'
PORT="38081"
##########################################################################################
############################################################
@route('/start/')
@route('/start/<prog_name>')
def start(prog_name=''):
	''' Start program in pdb mode
	http://127.0.0.1:38081/start/test.py'''
	if(len(prog_name)>0):
		return({'Return':"%s started"%(prog_name)})
	else:
		return template('Goto <a>{{redir_url}}</a>. Missing prog_name', redir_url="http://127.0.0.1:38081/test.py")
############################################################



##########################################################################################
run(host=IP, port=PORT, debug=True)
##########################################################################################


    
