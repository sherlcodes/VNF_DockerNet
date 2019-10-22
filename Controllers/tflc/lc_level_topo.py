__author__ = 'Zhang Shaojun'

# this script is to define and store the local-controller level
# topology, which is used for generating inter-domain flow

import networkx

LC_LEVEL_TOPO = networkx.DiGraph()
LC_LEVEL_TOPO.add_node(1, {'type': 'controller', 'win_dpid': [3]})
LC_LEVEL_TOPO.add_node(2, {'type': 'controller', 'win_dpid': [1]})

LC_LEVEL_TOPO.add_edge(1, 2, {'left_dpid': 1, 'out_port': 3, 'right_dpid': 2, 'in_port': 1})        # out_port reversed for future functions
LC_LEVEL_TOPO.add_edge(2, 1, {'left_dpid': 2, 'out_port': 1, 'right_dpid': 2, 'in_port': 1})

win_dpid_to_lcid = {1: 1, 2: 2}            # {dpid:lcid}, the lcid that the window dpid connected to
