# Copyright (C) 2013 Nippon Telegraph and Telephone Corporation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import json
import sys
from ryu.controller import handler
from ryu.app.wsgi import ControllerBase
from ryu.app.wsgi import Response
from ryu.app.wsgi import route
from ryu.topology import event, switches
#from ryu.app.wsgi import WSGIApplication
from ryu.controller.dpset import *
from ryu.base import app_manager
from ryu.lib import dpid as dpid_lib
from ryu.topology.api import get_switch, get_link, get_host


DPSET_EV_DISPATCHER = "dpset"

# REST API for switch configuration
#
# get all the switches
# GET /v1.0/topology/switches
#
# get the switch
# GET /v1.0/topology/switches/<dpid>
#
# get all the links
# GET /v1.0/topology/links
#
# get the links of a switch
# GET /v1.0/topology/links/<dpid>
#
# get all the hosts
# GET /v1.0/topology/hosts
#
# get the hosts of a switch
# GET /v1.0/topology/hosts/<dpid>
#
# where
# <dpid>: datapath id in 16 hex

'''
class TopologyAPI(app_manager.RyuApp):
    _CONTEXTS = {
        'wsgi': WSGIApplication
    }

    def __init__(self, *args, **kwargs):
        super(TopologyAPI, self).__init__(*args, **kwargs)

        wsgi = kwargs['wsgi']
        wsgi.register(TopologyController, {'topology_api_app': self})

'''
############################################################################
class TopoApplication(object):
    #########################################
    def __init__(self, *args, **kwargs):
        super(DPSet, self).__init__(*args, **kwargs)
        self.name = 'dpset'

        self.dps = {}   # datapath_id => class Datapath
        self.port_state = {}  # datapath_id => ports
    #########################################
    def _register(self, dp):
        LOG.debug('DPSET: register datapath %s', dp)
        assert dp.id is not None

        # while dpid should be unique, we need to handle duplicates here
        # because it's entirely possible for a switch to reconnect us
        # before we notice the drop of the previous connection.
        # in that case,
        # - forget the older connection as it likely will disappear soon
        # - do not send EventDP leave/enter events
        # - keep the PortState for the dpid
        send_dp_reconnected = False
        if dp.id in self.dps:
            self.logger.warning('DPSET: Multiple connections from %s',
                                dpid_to_str(dp.id))
            self.logger.debug('DPSET: Forgetting datapath %s', self.dps[dp.id])
            (self.dps[dp.id]).close()
            self.logger.debug('DPSET: New datapath %s', dp)
            send_dp_reconnected = True
        self.dps[dp.id] = dp
        if dp.id not in self.port_state:
            self.port_state[dp.id] = PortState()
            ev = EventDP(dp, True)
            with warnings.catch_warnings():
                warnings.simplefilter('ignore')
                for port in dp.ports.values():
                    self._port_added(dp, port)
                    ev.ports.append(port)
            self.send_event_to_observers(ev)
        if send_dp_reconnected:
            ev = EventDPReconnected(dp)
            ev.ports = self.port_state.get(dp.id, {}).values()
            self.send_event_to_observers(ev)
    #########################################
    def _unregister(self, dp):
        # see the comment in _register().
        if dp not in self.dps.values():
            return
        LOG.debug('DPSET: unregister datapath %s', dp)
        assert self.dps[dp.id] == dp

        # Now datapath is already dead, so port status change event doesn't
        # interfere us.
        ev = EventDP(dp, False)
        for port in list(self.port_state.get(dp.id, {}).values()):
            self._port_deleted(dp, port)
            ev.ports.append(port)

        self.send_event_to_observers(ev)

        del self.dps[dp.id]
        del self.port_state[dp.id]
    #########################################
    def get(self, dp_id):
        """
        This method returns the ryu.controller.controller.Datapath
        instance for the given Datapath ID.
        """
        return self.dps.get(dp_id)
    #########################################
    def get_all(self):
        """
        This method returns a list of tuples which represents
        instances for switches connected to this controller.
        The tuple consists of a Datapath ID and an instance of
        ryu.controller.controller.Datapath.

        A return value looks like the following::

            [ (dpid_A, Datapath_A), (dpid_B, Datapath_B), ... ]
        """
        return list(self.dps.items())
    #########################################
    def _port_added(self, datapath, port):
        self.port_state[datapath.id].add(port.port_no, port)
    #########################################
    def _port_deleted(self, datapath, port):
        self.port_state[datapath.id].remove(port.port_no)
    #########################################
    @set_ev_cls(ofp_event.EventOFPStateChange,
                [handler.MAIN_DISPATCHER, handler.DEAD_DISPATCHER])
    def dispatcher_change(self, ev):
        datapath = ev.datapath
        assert datapath is not None
        if ev.state == handler.MAIN_DISPATCHER:
            self._register(datapath)
        elif ev.state == handler.DEAD_DISPATCHER:
            self._unregister(datapath)
    #########################################
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, handler.CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        msg = ev.msg
        datapath = msg.datapath
        # ofp_handler.py does the following so we could remove...
        if datapath.ofproto.OFP_VERSION < 0x04:
            datapath.ports = msg.ports
    #########################################
    @set_ev_cls(ofp_event.EventOFPPortStatus, handler.MAIN_DISPATCHER)
    def port_status_handler(self, ev):
        msg = ev.msg
        reason = msg.reason
        datapath = msg.datapath
        port = msg.desc
        ofproto = datapath.ofproto

        if reason == ofproto.OFPPR_ADD:
            LOG.debug('DPSET: A port was added.' +
                      '(datapath id = %s, port number = %s)',
                      dpid_to_str(datapath.id), port.port_no)
            self._port_added(datapath, port)
            self.send_event_to_observers(EventPortAdd(datapath, port))
        elif reason == ofproto.OFPPR_DELETE:
            LOG.debug('DPSET: A port was deleted.' +
                      '(datapath id = %s, port number = %s)',
                      dpid_to_str(datapath.id), port.port_no)
            self._port_deleted(datapath, port)
            self.send_event_to_observers(EventPortDelete(datapath, port))
        else:
            assert reason == ofproto.OFPPR_MODIFY
            LOG.debug('DPSET: A port was modified.' +
                      '(datapath id = %s, port number = %s)',
                      dpid_to_str(datapath.id), port.port_no)
            self.port_state[datapath.id].modify(port.port_no, port)
            self.send_event_to_observers(EventPortModify(datapath, port))
    #########################################
    def get_port(self, dpid, port_no):
        """
        This method returns the ryu.controller.dpset.PortState
        instance for the given Datapath ID and the port number.
        Raises ryu_exc.PortNotFound if no such a datapath connected to
        this controller or no such a port exists.
        """
        try:
            return self.port_state[dpid][port_no]
        except KeyError:
            raise ryu_exc.PortNotFound(dpid=dpid, port=port_no,
                                       network_id=None)
    #########################################
    def get_ports(self, dpid):
        """
        This method returns a list of ryu.controller.dpset.PortState
        instances for the given Datapath ID.
        Raises KeyError if no such a datapath connected to this controller.
        """
        return list(self.port_state[dpid].values())
############################################################################
class TopologyController(ControllerBase):
    def __init__(self, req, link, data, graph_store=None,**config):
        super(TopologyController, self).__init__(req, link, data, **config)
        self.logger.info("*** "+sys._getframe(  ).f_code.co_name)
        self.topology_api_app = data['topology_api_app']
    #########################################
    def list_switches(self, req, **kwargs):
        self.logger.info("*** "+sys._getframe(  ).f_code.co_name)
        return self._switches(req, **kwargs)
    #########################################
    def get_switch(self, req, **kwargs):
        self.logger.info("*** "+sys._getframe(  ).f_code.co_name)
        return self._switches(req, **kwargs)
    #########################################
    def list_links(self, req, **kwargs):
        self.logger.info("*** "+sys._getframe(  ).f_code.co_name)
        return self._links(req, **kwargs)
    #########################################
    def get_links(self, req, **kwargs):
        self.logger.info("*** "+sys._getframe(  ).f_code.co_name)
        return self._links(req, **kwargs)
    #########################################
    def list_hosts(self, req, **kwargs):
        return self._hosts(req, **kwargs)
    #########################################
    def get_hosts(self, req, **kwargs):
        return self._hosts(req, **kwargs)
    #########################################
    def _switches(self, req, **kwargs):
        dpid = None
        if 'dpid' in kwargs:
            dpid = dpid_lib.str_to_dpid(kwargs['dpid'])
        switches = get_switch(self.topology_api_app, dpid)
        body = [switch.to_dict() for switch in switches]
        return(body)
    #########################################
    def _links(self, req, **kwargs):
        dpid = None
        if 'dpid' in kwargs:
            dpid = dpid_lib.str_to_dpid(kwargs['dpid'])
        links = get_link(self.topology_api_app, dpid)
        body = [link.to_dict() for link in links]
        return(body)
    #########################################
    def _hosts(self, req, **kwargs):
        dpid = None
        if 'dpid' in kwargs:
            dpid = dpid_lib.str_to_dpid(kwargs['dpid'])
        hosts = get_host(self.topology_api_app, dpid)
        body = [host.to_dict() for host in hosts]
        return(body)
############################################################################