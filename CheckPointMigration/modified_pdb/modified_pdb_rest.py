#!/usr/bin/python2.7
from bottle import route, run, template
import time, subprocess, json, sys
#import pdb
#import os
import modified_pdb as pdb
#from bottledaemon import daemon_run
"""
PdbRest adds a REST API to Pdb.
"""
IP='localhost'
PORT="38081"
##########################################################################################
class WrapperPDB(pdb.Pdb):
	def __init__(self, completekey='tab', stdin=None, stdout=None, skip=None):
		self.pdbObj=pdb.Pdb.__init__(self,completekey, stdin, stdout, skip)
		if stdin or stdout:
			self.use_rawinput = 0
	############################################################
	def do_EOF(self, arg):
		import sys
		print >>self.stdout
		#self._user_requested_quit = 1
		#self.set_quit()
		self.stdin = sys.stdin
		return 0

##########################################################################################

wpdb=None
@route('/start/')
@route('/start/<prog_name>')
def start(prog_name=''):
        ''' Start program in pdb mode
        http://127.0.0.1:38081/start/test.py'''
        if(len(prog_name)>0):
                import os
                if not os.path.exists(prog_name):
                        print('Error:', prog_name, 'does not exist')
                        sys.exit(1)
                #sys.stdin = open('input.txt')
                wpdb = WrapperPDB(stdin=open('input.txt',"r"))
                wpdb._runscript(prog_name)
                '''while True:
                        wpdb._runscript(prog_name)
                        if wpdb._user_requested_quit:
                                break
                        else:
                                print("Execution continued")
                '''
                return({'Return':"%s Pdb session exited"%(prog_name)})
        else:
                return template('Goto <a>{{redir_url}}</a>. Missing prog_name', redir_url="http://127.0.0.1:38081/test.py")
############################################################
@route('/hello/')
def start():
	return ({"Response":"hello"})
##########################################################################################
run(host=IP, port=PORT, debug=True)
##########################################################################################
